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

  has_many :lessons, :dependent => :destroy
  has_many :subscriptions, :dependent => :destroy

  accepts_nested_attributes_for :course, :allow_destroy => true
  accepts_nested_attributes_for :lessons, :allow_destroy => true

  enum :status => %i[pending reviewed approved]

  def next
    course.subjects.find_by "subjects.sequential_id > ?", sequential_id
  end

  def prev
    course.subjects.find_by "subjects.sequential_id < ?", sequential_id
  end
end
