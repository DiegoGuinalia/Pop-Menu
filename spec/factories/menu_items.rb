FactoryBot.define do
  factory :menu_item do
    association :menu
    association :item

    price { Faker::Number.decimal(l_digits: 2) }
  end
end
