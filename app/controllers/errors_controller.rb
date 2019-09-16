class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
      format.any { render status: :not_found, plain: 'Not Found' }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.html { render status: :internal_server_error }
      format.any { render status: :internal_server_error, plain: 'Internal Server Error' }
    end
  end

  def forbidden
    respond_to do |format|
      format.html { render status: :forbidden }
      format.any { render status: :forbidden, plain: 'Forbidden' }
    end
  end
end
