# Courses model
class Course < ApplicationRecord
  belongs_to :owner, :class_name => :User, :foreign_key => :owner_id, :inverse_of => :user
  translates :name, :description, :notes
end
