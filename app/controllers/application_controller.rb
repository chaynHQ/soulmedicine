# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ErrorHandlers

  before_action :set_locale

  protected

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    LocalesService.current = locale
  end

  def default_url_options
    { locale: LocalesService.current }
  end

  def auth_service
    @auth_service ||= AuthService.new
  end

  def courses_service
    @courses_service ||= CoursesService.new(STORYBLOK_CLIENT)
  end

  def current_user
    @current_user ||= User.find(session[:user]) if session[:user]
  end
  helper_method :current_user

  def authorize
    session.delete(:forwarding_url)
    return if current_user

    session[:forwarding_url] = request.original_url if request.get?
    flash[:danger] = 'Please Sign In'
    redirect_to controller: 'auth', action: 'sign_in'
  end
end
