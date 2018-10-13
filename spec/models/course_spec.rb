# == Schema Information
#
# Table name: courses
#
#  id            :bigint(8)        not null, primary key
#  sequential_id :integer
#  active        :boolean
#  approved      :boolean
#  owner_id      :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :integer
#

require "rails_helper"

RSpec.describe Course, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
