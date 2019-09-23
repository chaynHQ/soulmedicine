class CoursesController < ApplicationController
  def index
    current_locale = LocalesService.current.to_s

    @courses, @other_courses = courses_service.list.partition do |c|
      c.enabled_languages.include? current_locale
    end
  end

  def show
    @course = courses_service.get params[:id]

    @subscription = (current_user.subscriptions.find_by(course_slug: @course.slug) if current_user?)

    @vote_total = Vote.get_course_vote_total(@course.slug)
  end
end
