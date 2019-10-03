class Backup < ApplicationRecord
  validates :key,
    presence: true,
    uniqueness: true

  validates :data,
    presence: true
end
