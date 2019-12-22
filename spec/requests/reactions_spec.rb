require 'rails_helper'

RSpec.describe 'Reactions', type: :request do
  describe 'update - PUT/PATCH /pathways/:course_id/notes/:lesson_id/reaction' do
    let(:course) { load_course('course-1.json') }
    let(:lesson) { course.lessons.first }

    let(:reaction_name) { 'safe' }

    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        expect_any_instance_of(NoteReaction).to receive(:destroy!).never

        patch course_lesson_reaction_url(
          course_id: course.slug,
          lesson_id: lesson.slug,
          reaction_name: reaction_name
        )
      end
    end

    it_behaves_like 'authenticated' do
      let(:other_user) { create :user }

      before do
        # Create another separate reaction for a different user
        create :note_reaction,
          course_slug: course.slug,
          lesson_slug: lesson.slug,
          reaction_name: 'empowered',
          user: other_user
      end

      context 'when the current user does not yet have a reaction for the note' do
        it 'creates a new reaction for the current_user' do
          expect do
            put course_lesson_reaction_path(
              course_id: course.slug,
              lesson_id: lesson.slug,
              reaction_name: reaction_name
            )
          end.to change(NoteReaction, :count).from(1).to(2)

          expect(current_user.note_reactions.count).to eq 1
          expect(other_user.note_reactions.count).to eq 1

          note_reaction = current_user.note_reactions.first
          expect(note_reaction.course_slug).to eq course.slug
          expect(note_reaction.lesson_slug).to eq lesson.slug
          expect(note_reaction.reaction_name).to eq reaction_name

          expect(other_user.note_reactions.first.reaction_name).to eq 'empowered'
        end
      end

      context 'when the current user already has a reaction for the note' do
        before do
          create :note_reaction,
            course_slug: course.slug,
            lesson_slug: lesson.slug,
            reaction_name: 'strong',
            user: current_user
        end

        it 'updates the reaction' do
          expect do
            put course_lesson_reaction_path(
              course_id: course.slug,
              lesson_id: lesson.slug,
              reaction_name: reaction_name
            )
          end.not_to change(NoteReaction, :count)

          expect(current_user.note_reactions.count).to eq 1
          expect(other_user.note_reactions.count).to eq 1

          note_reaction = current_user.note_reactions.first
          expect(note_reaction.course_slug).to eq course.slug
          expect(note_reaction.lesson_slug).to eq lesson.slug
          expect(note_reaction.reaction_name).to eq reaction_name

          expect(other_user.note_reactions.first.reaction_name).to eq 'empowered'
        end
      end
    end
  end

  describe 'destroy - DELETE /pathways/:course_id/notes/:lesson_id/reaction' do
    let(:course) { load_course('course-1.json') }
    let(:lesson) { course.lessons.first }

    it_behaves_like 'unauthenticated redirects to sign in' do
      before do
        expect_any_instance_of(NoteReaction).to receive(:destroy!).never

        delete course_lesson_reaction_url(
          course_id: course.slug,
          lesson_id: lesson.slug,
          reaction_name: 'safe'
        )
      end
    end

    it_behaves_like 'authenticated' do
      let(:other_user) { create :user }

      before do
        create :note_reaction,
          course_slug: course.slug,
          lesson_slug: lesson.slug,
          reaction_name: 'safe',
          user: current_user

        # Create another separate reaction for a different user
        create :note_reaction,
          course_slug: course.slug,
          lesson_slug: lesson.slug,
          reaction_name: 'empowered',
          user: other_user
      end

      it 'removes the reaction for the current_user only' do
        expect do
          delete course_lesson_reaction_url(
            course_id: course.slug,
            lesson_id: lesson.slug,
            reaction_name: 'safe'
          )
        end.to change(NoteReaction, :count).from(2).to(1)

        expect(current_user.note_reactions.count).to eq 0
        expect(other_user.note_reactions.count).to eq 1
      end
    end
  end

  describe 'set_from_email - GET /pathways/:course_id/notes/:lesson_id/reaction/set_from_email' do
    let(:user) { create :user }
    let(:course) { load_course('course-1.json') }
    let(:lesson) { course.lessons.first }

    let(:reaction_name) { 'safe' }

    it 'creates a new reaction for the user specified' do
      expect do
        get set_from_email_course_lesson_reaction_url(
          course_id: course.slug,
          lesson_id: lesson.slug,
          reaction_name: reaction_name,
          user_id: user.to_sgid_param(for: :set_reaction)
        )
      end.to change(NoteReaction, :count).from(0).to(1)

      note_reaction = NoteReaction.first
      expect(note_reaction.course_slug).to eq course.slug
      expect(note_reaction.lesson_slug).to eq lesson.slug
      expect(note_reaction.reaction_name).to eq reaction_name
      expect(note_reaction.user).to eq user
    end
  end
end
