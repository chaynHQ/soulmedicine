class PagesController < ApplicationController
  def landing
    params[:id] = 'landing'
    show
  end

  def show
    @page = pages_service.get params[:id]
    render :show
  end
end
