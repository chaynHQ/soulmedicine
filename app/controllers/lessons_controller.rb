class LessonsController < ApplicationController
  def show
    course_id = params[:course_id]
    lesson_id = params[:id]

    @course, @lesson = courses_service.get_course_and_lesson(
      course_id,
      lesson_id
    )

    @next_lesson = @course.next_lesson(@lesson.slug)
    @previous_lesson = @course.previous_lesson(@lesson.slug)

    # TODO: set this properly
    @reaction = false

    @possible_reactions = NoteReaction.reaction_names.keys unless @reaction
  end
end
