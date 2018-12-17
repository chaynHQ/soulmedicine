require 'rails_helper'

RSpec.describe CoursesService, type: :service do
  let(:storyblok_client) { instance_double 'Storyblok::Client' }

  subject { described_class.new storyblok_client }

  def load_json(filename)
    JSON.parse file_fixture(filename).read
  end

  def mock_courses_list_api(data)
    allow(storyblok_client).to receive(:stories)
      .with(
        starts_with: 'courses',
        excluding_fields: 'lessons'
      )
      .and_return('data' => data)
  end

  def mock_course_api(slug, data)
    allow(storyblok_client).to receive(:story)
      .with("courses/#{slug}")
      .and_return('data' => data)
  end

  describe '#list' do
    before do
      mock_courses_list_api data
    end

    context 'with no courses' do
      let(:data) { { 'stories' => [] } }

      it 'returns an empty list' do
        expect(subject.list).to eq []
      end
    end

    context 'with courses' do
      let(:data) { load_json('courses-list.json') }

      it 'maps the courses data to objects as expected' do
        results = subject.list
        expect(results.size).to eq 1
        expect(results.first).to be_a Course
        expect(results.first.slug).to eq 'diy-online-safety'
        expect(results.first.name).to eq 'How to be safe online'
        expect(results.first.name_en).to eq 'How to be safe online'
      end
    end

    context 'when an upstream CMS error is caught' do
      let(:data) { [] }

      before do
        allow(storyblok_client).to receive(:stories)
          .with(
            starts_with: 'courses',
            excluding_fields: 'lessons'
          )
          .and_raise(RestClient::RequestFailed)
      end

      it 'raises a CmsAccessError with the upstream error as the cause' do
        expect { subject.list }.to raise_error do |error|
          expect(error).to be_a CoursesService::CmsAccessError
          expect(error.cause).to be_a RestClient::RequestFailed
        end
      end
    end
  end

  describe '#get' do
    before do
      mock_course_api slug, data
    end

    let(:slug) { 'diy-online-safety' }

    let(:data) { load_json('course-1.json') }

    it 'maps the course data to objects as expected' do
      course = subject.get slug

      expect(course).to be_a Course
      expect(course.slug).to eq slug
      expect(course.name).to eq 'How to be safe online'
      expect(course.lessons.size).to be 2
      expect(course.lessons.first).to be_a Lesson
      expect(course.lessons.map(&:slug)).to match_array ['how-many-sites-and-services-do-you-use', 'easy-wins-part-1']
      expect(course.lessons.map(&:name)).to match_array ['Lesson 1 - How many sites and services do you use?', 'Lesson 2 - Easy Wins Part 1']
    end

    it 'raises a NotFound error if the slug provided is blank' do
      expect { subject.get nil }.to raise_error(CoursesService::NotFound)
    end
  end

  describe '#get_course_and_lesson' do
    before do
      mock_course_api course_slug, data
    end

    let(:course_slug) { 'diy-online-safety' }
    let(:lesson_slug) { 'easy-wins-part-1' }

    let(:data) { load_json('course-1.json') }

    it 'returns both the course and found lesson within that course' do
      course, lesson = subject.get_course_and_lesson(course_slug, lesson_slug)

      expect(course).to be_a Course
      expect(course.slug).to eq course_slug

      expect(lesson).to be_a Lesson
      expect(lesson.slug).to eq lesson_slug
    end

    it 'raises a NotFound error if either slug provided is blank' do
      expect { subject.get_course_and_lesson nil, lesson_slug }.to raise_error(CoursesService::NotFound)

      expect { subject.get_course_and_lesson course_slug, nil }.to raise_error(CoursesService::NotFound)
    end

    it 'raises a NotFound error if the lesson does not exist within the course' do
      expect { subject.get_course_and_lesson course_slug, 'unknown' }.to raise_error(CoursesService::NotFound)
    end
  end
end
