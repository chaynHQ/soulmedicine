# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ErrorHandlers

  protected

  def courses_service
    @courses_service ||= CoursesService.new(STORYBLOK_CLIENT)
  end
end
