module Create
  class Restaurant < Base
    private

    def create_or_update_entity
      restaurant = if params[:id].present?
        ::Restaurant.find_by(id: params[:id])
      else
        ::Restaurant.find_by(name: params[:name])
      end

      if restaurant.nil?
        context.restaurant = ::Restaurant.create!(restaurant_data)
      else
        restaurant.update(name: params[:name]) if params[:name].present?
        context.restaurant = restaurant
      end
    end

    def set_associated_entity
      @associated_entity = context.restaurant
    end

    def restaurant_data
      { name: params[:name] }
    end
  end
end
