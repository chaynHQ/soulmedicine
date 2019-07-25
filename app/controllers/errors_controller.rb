class ErrorsController < ApplicationController
  def not_found
    render(:status => 404)
  end

  def internal_server_error
    render(:status => 500)
  end

  def forbidden
    render(:status => 403)
  end
end
