require 'rails_helper'

RSpec.describe 'Lessons', type: :request do
  let(:course) { load_course('course-1.json') }
  let(:lesson) {course.lessons.first}
  let(:courses_service) { instance_double('CoursesService') }

  describe 'show - GET /pathways/:course_id/:lesson_id' do
    it 'loads the lesson page' do

      params = {
        course_id: 'how-to-regain-your-confidence-after-trauma',
        id: 'note-1-regain-your-confidence'
      }

      allow(courses_service).to receive(:get_course_and_lesson).with(course.slug, lesson.slug).and_return([course, lesson.slug])

      get course_lesson_path(params)
      expect(controller).to have_received(:course)
      expect(response).to be_successful
      expect(response).to render_template(:show)
    end
  end

end
