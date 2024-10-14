class MenuSerializer < ActiveModel::Serializer
  attributes  :restaurant_id,
              :restaurant_name,
              :name,
              :menu_items

  has_many :menu_items

  def restaurant_name
    object.restaurant.name
  end

end
