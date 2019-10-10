class PagesController < ApplicationController
  def landing
    params[:id] = 'landing'
    @signedIn = params[:signed_in]
    @previous_course = courses_service.get params[:course_id] if params.has_key?(:course_id)
    show
  end

  def show
    @page = pages_service.get params[:id]
    render :show
  end
end
