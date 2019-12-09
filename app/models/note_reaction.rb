class NoteReaction < ApplicationRecord
  enum reaction_name: { empowered: 0, strong: 1, knowledgeable: 2, magical: 3, peaceful: 4 }

  belongs_to :user

  validates :course_slug,
    presence: true

  validates :lesson_slug,
    presence: true,
    uniqueness: { scope: %i[user_id course_slug] }
end
