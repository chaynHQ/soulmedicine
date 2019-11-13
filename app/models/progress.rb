class Progress < ApplicationRecord
  belongs_to :user

  validates :course_slug,
    presence: true

  validates :lesson_slug,
    presence: true,
    uniqueness: { scope: %i[user_id course_slug] }
end
