# == Schema Information
#
# Table name: subjects
#
#  id            :bigint(8)        not null, primary key
#  course_id     :bigint(8)
#  sequential_id :integer
#  status        :integer
#  approved      :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Subject < ApplicationRecord
  belongs_to :course
  translates :name, :description, :notes

  enum :status => %i[pending reviewed approved]
end
