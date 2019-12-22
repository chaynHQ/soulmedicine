require 'rails_helper'

RSpec.describe 'Lessons', type: :request do
  include_context 'courses_service double'

  let(:course) { load_course('course-1.json') }
  let(:lesson) { course.lessons.first }

  before do
    allow(courses_service).to receive(:get_course_and_lesson)
      .with(course.slug, lesson.slug)
      .and_return([course, lesson])
  end

  describe 'show - GET /pathways/:course_id/notes/:lesson_id' do
    context 'unauthenticated' do
      it 'loads the lesson page' do
        expect_any_instance_of(Progress).to receive(:save!).never

        get course_lesson_path(
          course_id: course.slug,
          id: lesson.slug
        )

        expect(response).to be_successful
        expect(response).to render_template(:show)

        expect(assigns(:course)).to eq course
        expect(assigns(:lesson)).to eq lesson
        expect(assigns(:reaction)).to eq nil
      end
    end

    it_behaves_like 'authenticated' do
      it 'loads the lesson page and tracks progress for the current_user' do
        expect do
          get course_lesson_path(
            course_id: course.slug,
            id: lesson.slug
          )
        end.to change(Progress, :count).from(0).to(1)

        expect(response).to be_successful
        expect(response).to render_template(:show)

        progress = current_user.progresses.first
        expect(progress.course_slug).to eq course.slug
        expect(progress.lesson_slug).to eq lesson.slug
      end

      it 'loads up an existing reaction for the current_user' do
        reaction = create :note_reaction,
          course_slug: course.slug,
          lesson_slug: lesson.slug,
          reaction_name: 'strong',
          user: current_user

        get course_lesson_path(
          course_id: course.slug,
          id: lesson.slug
        )

        expect(response).to be_successful
        expect(response).to render_template(:show)

        expect(assigns(:reaction)).to eq reaction
      end
    end
  end
end
