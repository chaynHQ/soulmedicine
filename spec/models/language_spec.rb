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
