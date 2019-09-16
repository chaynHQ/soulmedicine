module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from CoursesService::NotFound, with: :not_found_error
  end

  protected

  def not_found_error
    raise ActionController::RoutingError, 'Not Found'
  end
end
