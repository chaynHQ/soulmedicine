# Static pages
class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  def landing; end

  def about; end

  def contact; end
end
