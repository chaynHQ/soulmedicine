# Languages on the platform
class Language < ApplicationRecord
  validates_presence_of %i[name locale]
  validates :name, :uniqueness => true
end
