require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:courses_service) { instance_double('CoursesService') }

  let(:course) { load_course('course-1.json') }

  before do
    allow_any_instance_of(Subscription).to receive(:courses_service)
      .and_return(courses_service)
  end

  describe '#course' do
    subject do
      build :subscription,
        course_slug: slug,
        main_language: course.enabled_languages.first
    end

    context 'when course_slug is not set' do
      let(:slug) { nil }

      it 'returns nil' do
        expect(courses_service).to receive(:get).never
        expect(subject.course).to be nil
      end
    end

    context 'when course does not exist' do
      let(:slug) { course.slug }

      it 'returns nil' do
        expect(courses_service).to receive(:get)
          .with(slug)
          .and_raise(CoursesService::NotFound)
        expect(subject.course).to be nil
      end
    end

    context 'when course_slug is set and course exists' do
      let(:slug) { course.slug }

      it 'returns the course object' do
        expect(courses_service).to receive(:get)
          .with(slug)
          .and_return(course)
        expect(subject.course).to be course
      end
    end
  end
end
