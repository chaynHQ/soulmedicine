# == Schema Information
#
# Table name: courses
#
#  id            :bigint(8)        not null, primary key
#  active        :boolean
#  approved      :boolean
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :bigint(8)
#  sequential_id :integer
#
# Indexes
#
#  index_courses_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
class Course < ApplicationRecord
  belongs_to :owner, :class_name => :User, :foreign_key => :owner_id, :inverse_of => :user
  translates :name, :description, :notes

  enum :status => %i[pending reviewed approved]
end
