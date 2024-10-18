FactoryBot.define do
  factory :menu do
    association :restaurant

    name { Faker::Music::Opera.beethoven }
  end
end
