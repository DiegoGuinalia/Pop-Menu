class MenuSerializer < ActiveModel::Serializer
  attributes  :restaurant_id,
              :name,
              :menu_items

  has_many :menu_items
end
