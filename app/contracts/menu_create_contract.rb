class MenuCreateContract < Dry::Validation::Contract
  params do
    required(:restaurant_name).value(:string)
    required(:name).value(:string)

    required(:menu_items).array(:hash) do
      required(:name).value(:string)
      required(:price).value(:float)
    end
  end
end
