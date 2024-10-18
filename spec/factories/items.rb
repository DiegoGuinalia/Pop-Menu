FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
  end
end
