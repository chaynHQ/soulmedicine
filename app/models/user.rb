class User < ApplicationRecord
  validates :display_name, presence: true
  validates :uid, presence: true, uniqueness: true
  validates :email, presence: true

  scope :active, -> { where(email_verified: true) }
end
