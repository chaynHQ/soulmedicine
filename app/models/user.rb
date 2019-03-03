class User < ApplicationRecord
  validates :display_name,
    presence: true

  validates :firebase_id,
    presence: true,
    uniqueness: true

  validates :email,
    presence: true,
    uniqueness: true

  scope :verified, -> { where(email_verified: true) }

  has_many :subscriptions, dependent: :destroy

  def verified?
    email_verified == true
  end
end
