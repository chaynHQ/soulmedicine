class PagesController < ApplicationController
  def landing
    @courses = CoursesService.new(STORYBLOK_CLIENT).list
  end
end
