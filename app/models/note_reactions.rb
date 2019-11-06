class NoteReactions < ApplicationRecord
  
  enum type: [:empowered, :strong, :knowledable, :magical, :peaceful]
  
  belongs_to :user

  validates :course_slug,
    presence: true,

  validates :lesson_slug,
    presence: true,
    uniqueness: { scope: [:user_id, :course_slug] }
  
end