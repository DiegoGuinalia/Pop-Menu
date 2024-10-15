module Create
  class Restaurant < Base
    private

    def create_or_update_entity
      restaurant = if params[:id].present?
        ::Restaurant.find_by(id: params[:id])
      else
        ::Restaurant.find_by(name: params[:restaurant_name])
      end

      if restaurant.nil?
        return context.restaurant = ::Restaurant.create!(restaurant_data)
      end

      if params[:restaurant_name].present? && params[:restaurant_name] != restaurant.name
        restaurant.update(name: params[:restaurant_name])
      end

      context.restaurant = restaurant.reload
    end

    def set_associated_entity
      @associated_entity = context.restaurant
    end

    def restaurant_data
      { name: params[:name] }
    end
  end
end
