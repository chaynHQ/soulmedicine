# == Schema Information
#
# Table name: lessons
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
#  index_lessons_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
class Lesson < ApplicationRecord
  belongs_to :course

  extend Mobility
  translates :content, :notes

  has_many :subscriptions, :dependent => :destroy

  validates :name,
            :uniqueness => { :scope => :subject }
  validates :sequential_id,
            :presence => true,
            :numericality => true,
            :uniqueness => { :scope => :subject }
  validates :subject_id, :presence => true, :numericality => true

  default_scope { order(:sequential_id) }

  def next
    subject.lessons.find_by "lessons.sequential_id > ?", sequential_id
  end

  def prev
    subject.lessons.find_by "lessons.sequential_id < ?", sequential_id
  end
end
