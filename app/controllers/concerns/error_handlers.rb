module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from CoursesService::CmsAccessError, with: :cms_error
    rescue_from CoursesService::NotFound, with: :not_found_error
  end

  protected

  def cms_error
    render file: Rails.root.join('public', '500.html'), layout: false, status: :internal_server_error
  end

  def not_found_error
    render file: Rails.root.join('public', '404.html'), layout: false, status: :not_found
  end
end
