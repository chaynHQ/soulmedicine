class ErrorsController < ApplicationController
  before_action :set_format

  def not_found
    render(status: :not_found)
  end

  def internal_server_error
    render(status: :internal_server_error)
  end

  def forbidden
    render(status: :forbidden)
  end

  private

   def set_format
    request.format = :html
  end
  
end
