class LessonsController < ApplicationController
  def show
    course_id = params[:course_id]
    lesson_id = params[:id]

    @course, @current_lesson, @next_lesson, @previous_lesson = courses_service.get_course_and_lesson(
      course_id,
      lesson_id
    )

  end
end
