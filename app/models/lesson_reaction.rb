class LessonReaction < ApplicationRecord
  enum reaction_name: {
    empowered: 'empowered',
    strong: 'strong',
    knowledgeable: 'knowledgeable',
    safe: 'safe',
    motivated: 'motivated'
  }

  belongs_to :user

  validates :course_slug,
    presence: true

  validates :lesson_slug,
    presence: true,
    uniqueness: { scope: %i[user_id course_slug] }

  validates :reaction_name,
    presence: true
end
