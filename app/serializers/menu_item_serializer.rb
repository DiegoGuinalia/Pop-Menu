class MenuItemSerializer < ActiveModel::Serializer
  attributes :name, :price

  def name
    object.item.name
  end
end
