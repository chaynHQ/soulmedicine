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

    @reacted = helpers.user_reacted?(current_user, course_id, lesson_id)
    
    @reaction = current_user.note_reactions.find_by(course_slug: @course.slug, lesson_slug: @lesson.slug) if current_user?
    
    # puts ' *****'
    # puts @reaction
    # puts @reaction.lesson_slug
    # puts @reaction.course_slug
    # puts @reaction.reaction_name
    # puts '*****'
    @possible_reactions = NoteReaction.reaction_names.keys
  end
end
