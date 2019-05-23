# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend Memoist

  self.abstract_class = true

  def courses_service
    CoursesService.new(STORYBLOK_CLIENT)
  end
  memoize :courses_service
end
