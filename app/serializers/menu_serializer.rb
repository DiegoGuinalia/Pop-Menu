class MenuSerializer < ActiveModel::Serializer
attributes    :id,
              :name,
              :restaurant_id,
              :restaurant_name

  has_many :menu_items

  def restaurant_name
    object.restaurant.name
  end
end
