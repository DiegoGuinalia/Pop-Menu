module Create
  class Restaurant
    include Interactor
    include Utils

    delegate :params, to: :context

    def call
      within_transaction do
        find_or_create_restaurant
      end
    end

    private

    def find_or_create_restaurant
      restaurant = ::Restaurant.find_by(name: params[:restaurant_name])

      if restaurant.nil?
        return context.restaurant = ::Restaurant.create(name: params[:restaurant_name])
      end

      context.restaurant = restaurant
    end
  end
end
