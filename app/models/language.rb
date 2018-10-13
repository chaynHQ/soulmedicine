# == Schema Information
#
# Table name: languages
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  locale     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Languages on the platform
class Language < ApplicationRecord
  validates_presence_of %i[name locale]
  validates :name, :uniqueness => true
end
