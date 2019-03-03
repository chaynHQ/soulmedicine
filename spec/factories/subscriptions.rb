FactoryBot.define do
  factory :subscription do
    user
    days_utc { ['Mon'] }
    hours_utc { [0] }
  end
end
