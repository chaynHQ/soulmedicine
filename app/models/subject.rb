# == Schema Information
#
# Table name: subjects
#
#  id            :bigint(8)        not null, primary key
#  approved      :boolean
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  course_id     :bigint(8)
#  sequential_id :integer
#
# Indexes
#
#  index_subjects_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
class Subject < ApplicationRecord
  belongs_to :course
  translates :name, :description, :notes

  enum :status => %i[pending reviewed approved]
end
