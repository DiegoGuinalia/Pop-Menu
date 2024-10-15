module Create
  class MenuItems < Base
    private

    attr_reader :item_name

    def create_or_update_entity
      context.menu_items = []

      params[:menu_items].map do |menu_item_params|
        @item_name = menu_item_params[:name]

        menu_item = ::MenuItem.find_by(item: find_or_create_item, menu: context.menu)

        if menu_item.nil?
          context.menu_items << ::MenuItem.create!(
            menu_item_context(menu_item_params)
          )
        else
          context.menu_items << menu_item
        end
      end
      context.menu_items
    end

    def set_associated_entity
      @associated_entity = context.menu
    end

    def find_or_create_item
      item = ::Item.find_by(name: item_name)

      if item.nil?
        context.item = ::Item.create!(name: item_name)
      else
        context.item = item
      end

      context.item
    end

    def menu_item_context(menu_item_params)
      menu_items_parser = MenuItemsParser.new(menu_item_params)
      context.menu_items_data = menu_items_parser.run

      context.menu_items_data[:item_id] = context.item.id
      context.menu_items_data[:menu_id] = associated_entity.id
      context.menu_items_data
    end
  end
end
