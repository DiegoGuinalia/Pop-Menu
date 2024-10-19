# frozen_string_literal: true

class JsonDataParser
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def run
    set_menu_data
  end

  private

  def set_menu_data
    byebug
    return [] if params[:restaurants].nil?

    menu_data_array = params[:restaurants].flat_map do |restaurant|
      restaurant[:menus].map do |menu|
        menu_data = {
          "name": menu[:name],
          "restaurant_name": restaurant[:name]
        }

        menu_data.merge(set_menu_items_data(menu))
      end
    end

    menu_data_array
  end

  def set_menu_items_data(menu)
    menu_items = []

    if menu.key?(:menu_items)
      menu[:menu_items].each do |menu_item|
        menu_items << create_menu_item_data(menu_item)
      end
    elsif menu.key?(:dishes)
      menu[:dishes].each do |dish|
        menu_items << create_menu_item_data(dish)
      end
    end

    { "menu_items": menu_items }
  end

  def create_menu_item_data(menu_item)
    {
      "name": menu_item[:name],
      "price": menu_item[:price].to_s
    }
  end
end
