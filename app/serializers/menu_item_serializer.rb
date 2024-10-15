class MenuItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :menu_id

  def name
    object.item.name
  end
end
