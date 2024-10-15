module Create
  class Restaurant < Base
    private

    def create_or_update_entity
      restaurant = ::Restaurant.find_by(name: params[:restaurant_name])

      if restaurant.nil?
        context.restaurant = ::Restaurant.create!(restaurant_data)
      else
        context.restaurant = restaurant
      end
    end

    def set_associated_entity
      @associated_entity = context.restaurant
    end

    def restaurant_data
      { name: params[:restaurant_name] }
    end
  end
end
