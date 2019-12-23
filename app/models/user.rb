class User < ApplicationRecord
  validates :display_name,
    presence: true

  validates :firebase_id,
    presence: true,
    uniqueness: true

  validates :email,
    presence: true,
    uniqueness: true

  validates :terms_accepted,
    inclusion: { in: [true, false] }

  scope :verified, -> { where(email_verified: true) }

  has_many :subscriptions, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :lesson_reactions, dependent: :destroy
  has_many :progresses, dependent: :destroy

  def verified?
    email_verified == true
  end
end
