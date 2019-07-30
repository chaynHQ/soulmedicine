class ErrorsController < ApplicationController
  def not_found
    render(status: :not_found)
  end

  def internal_server_error
    render(status: :internal_server_error)
  end

  def forbidden
    render(status: :forbidden)
  end
end
