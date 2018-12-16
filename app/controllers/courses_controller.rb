class CoursesController < ApplicationController
  def index
    @courses = courses_service.list
  end

  def show
    @course = courses_service.get params[:id]
  end
end
