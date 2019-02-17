FactoryBot.define do
  factory :user do
    sequence :firebase_id do |n|
      "firebase_id_#{n}"
    end
    sequence :display_name do |n|
      "Miss #{n}"
    end
    sequence :email do |n|
      "miss_#{n}@example.com"
    end
  end
end
