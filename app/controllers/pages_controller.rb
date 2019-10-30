class PagesController < ApplicationController
  def landing
    params[:id] = 'landing'
    @just_signed_in = params[:just_signed_in]
    @previous_course = previous_course
    show
  end

  def show
    @page = pages_service.get params[:id]
    render :show
  end

  private

  def previous_course
    courses_service.get params[:last_course_id] if params.key?(:last_course_id)
  rescue CoursesService::NotFound
    nil
  end
end
