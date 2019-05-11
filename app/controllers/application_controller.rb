# frozen_string_literal: true

class ApplicationController < ActionController::Base
  extend Memoist

  include ErrorHandlers
  include Authentication

  before_action :set_locale

  after_action :set_content_language_header

  protected

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    LocalesService.current = locale
  end

  def set_content_language_header
    response.headers['Content-Language'] = LocalesService.current
  end

  def default_url_options
    { locale: LocalesService.current }
  end

  def courses_service
    CoursesService.new(STORYBLOK_CLIENT)
  end
  memoize :courses_service

  def pages_service
    PagesService.new(STORYBLOK_CLIENT)
  end
  memoize :pages_service
end
