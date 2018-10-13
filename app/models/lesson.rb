# == Schema Information
#
# Table name: lessons
#
#  id            :bigint(8)        not null, primary key
#  subject_id    :bigint(8)
#  sequential_id :integer
#  status        :integer
#  approved      :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Lesson < ApplicationRecord
  belongs_to :subject
  translates :content, :notes
end
