# == Schema Information
#
# Table name: lessons
#
#  id            :bigint(8)        not null, primary key
#  approved      :boolean
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sequential_id :integer
#  subject_id    :bigint(8)
#
# Indexes
#
#  index_lessons_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (subject_id => subjects.id)
#
class Lesson < ApplicationRecord
  belongs_to :subject
  translates :content, :notes
end
