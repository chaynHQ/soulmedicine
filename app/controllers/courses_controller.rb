# Class to show Courses
class CoursesController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @course = Course.all
  end

  def show
    @course = Course.find_by(:sequential_id => params[:id])
  end
end
