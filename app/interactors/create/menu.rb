module Create
  class Menu
    include Interactor
    include Utils

    delegate :params, to: :context

    attr_accessor :restaurant

    def call
      set_restaurant

      within_transaction do
        create_menu
      end
    end

    private

    def create_menu
      menu = restaurant.menus.find_by(name: params[:name])

      if menu.nil?
        return context.menu = ::Menu.create!(menu_data)
      end

      menu.update(context.menu_data)
      context.menu = menu
    end

    def set_restaurant
      @restaurant = context.restaurant
    end

    def menu_data
      context.menu_data[:restaurant_id] = restaurant.id
      context.menu_data
    end
  end
end
