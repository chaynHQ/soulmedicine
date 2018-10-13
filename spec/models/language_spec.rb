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

require "rails_helper"

RSpec.describe Language, :type => :model do
  subject { described_class.new(:name => "english", :active => true, :locale => "en") }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a locale" do
    subject.locale = nil
    expect(subject).to_not be_valid
  end
end
