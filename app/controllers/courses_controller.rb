class CoursesController < ApplicationController
  def index
    current_locale = LocalesService.current.to_s

    @courses, @other_courses = courses_service.list.partition do |c|
      c.enabled_languages.include? current_locale
    end
  end

  def show
    @course = courses_service.get params[:id]
  end
end
