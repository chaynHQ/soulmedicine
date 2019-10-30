class PagesController < ApplicationController
  def landing
    params[:id] = 'landing'
    @signed_in = params[:signed_in]
    @previous_course = courses_service.get params[:last_course_id] if params.key?(:last_course_id)
    show
  end

  def show
    @page = pages_service.get params[:id]
    render :show
  end
end
