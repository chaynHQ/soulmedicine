# == Schema Information
#
# Table name: courses
#
#  id            :bigint(8)        not null, primary key
#  sequential_id :integer
#  active        :boolean
#  approved      :boolean
#  owner_id      :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :integer
#
class Course < ApplicationRecord
  belongs_to :owner, :class_name => :User, :foreign_key => :owner_id, :inverse_of => :user
  translates :name, :description, :notes

  enum :status => %i[pending reviewed approved]
end
