# == Schema Information
#
# Table name: subjects
#
#  id            :bigint(8)        not null, primary key
#  course_id     :bigint(8)
#  sequential_id :integer
#  status        :integer
#  approved      :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe Subject, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
