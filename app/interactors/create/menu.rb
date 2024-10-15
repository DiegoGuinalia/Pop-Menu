module Create
  class Menu < Base
    private

    def create_or_update_entity
      menu = associated_entity.menus.find_by(name: params[:name])

      if menu.nil?
        return context.menu = ::Menu.create!(entity_data)
      end

      menu.update(context.menu_data)
      context.menu = menu
    end

    def set_associated_entity
      @associated_entity = context.restaurant
    end

    def entity_data
      context.menu_data[:restaurant_id] = associated_entity.id
      context.menu_data
    end
  end
end
