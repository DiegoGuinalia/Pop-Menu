class RestaurantSerializer < ActiveModel::Serializer
  attributes  :name

  has_many :menus
end
