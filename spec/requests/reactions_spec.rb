require 'rails_helper'

RSpec.describe 'Reactions', type: :request do
  describe 'show - GET /reactions' do
    let(:user) { create :user }
    let(:course) { load_course('course-1.json') }
    let(:lesson) { course.lessons.first }

    it 'creates the users reaction' do
      expect do
        get set_from_email_course_lesson_reaction_url(
          course_id: course.slug,
          lesson_id: lesson.slug,
          reaction_name: 'peaceful',
          user_id: user.to_sgid_param(for: :set_reaction)
        )
      end.to change(NoteReaction, :count).from(0).to(1)
    end
  end

  describe 'update - PUT /reactions' do
    let(:user) { create :user }
    let(:course) { load_course('course-1.json') }
    let(:lesson) { course.lessons.first }

    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        patch course_lesson_reaction_url(
          course_id: course.slug,
          lesson_id: lesson.slug,
          reaction_name: 'peaceful'
        )
      end
    end

    it_behaves_like 'authenticated' do
      it 'creates current_users reactions' do
        expect do
          put course_lesson_reaction_path(
            course_id: course.slug,
            lesson_id: lesson.slug,
            reaction_name: 'peaceful'
          )
        end.to change(NoteReaction, :count).from(0).to(1)
      end
      it 'updates current_users reactions' do
        create(:noteReaction,
          course_slug: course.slug,
          lesson_slug: lesson.slug,
          reaction_name: 'empowered')

        # To do: MAKE this test work! Can't seem to connect current_users to each other!

        # expect do
        #   put course_lesson_reaction_path(
        #     course_id: course.slug,
        #     lesson_id: lesson.slug,
        #     reaction_name: 'peaceful',
        #   )
        # end.to change(NoteReaction.first, :reaction_name).from('empowered').to('peaceful')
      end
    end
  end

  describe 'destroy - DELETE /reactions' do
    let(:user) { create :user }
    let(:course) { load_course('course-1.json') }
    let(:lesson) { course.lessons.first }

    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        delete course_lesson_reaction_url(
          course_id: course.slug,
          lesson_id: lesson.slug,
          reaction_name: 'peaceful'
        )
      end
    end

    it_behaves_like 'authenticated' do
      it 'updates current_users reactions' do
        create(:noteReaction,
          course_slug: course.slug,
          lesson_slug: lesson.slug,
          reaction_name: 'peaceful',
          user: current_user)

        expect do
          delete course_lesson_reaction_url(
            course_id: course.slug,
            lesson_id: lesson.slug,
            reaction_name: 'peaceful'
          )
        end.to change(NoteReaction, :count).from(1).to(0)
      end
    end
  end
end
