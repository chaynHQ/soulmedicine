class ErrorsController < ApplicationController

  def not_found
    # render :not_found, status: :not_found, content_type: 'text/html', format: 'html'
    respond_to do |format|
        format.any { render 'errors/not_found.html.erb',  layout: 'errors', status: :not_found, content_type: 'text/html', :formats => :html }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.any { render 'errors/internal_server_error.html.erb',  layout: 'errors', status: :internal_server_error, content_type: 'text/html', :formats => :html }
    end
  end

  def forbidden
    respond_to do |format|
      format.any { render 'errors/forbidden.html.erb',  layout: 'errors', status: :forbidden, content_type: 'text/html', :formats => :html }
    end
  end

end
