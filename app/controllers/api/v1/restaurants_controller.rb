class Api::V1::RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[show update]

  def index
    restaurant = Restaurant
      .order(:created_at)
      .paginate(page: params[:page], per_page: params[:per_page] || 30)

    json_pagination(
      restaurant,
      RestaurantSerializer
    )
  rescue => e
    return json_error_response(e.message, :bad_request)
  end

  def show
    return json_error_response('not found') unless @restaurant
    json_success_response(RestaurantSerializer.new(@restaurant))
  end

  def create_or_update
    result = Create::Restaurant.call(params: params)
    body(result, RestaurantSerializer.new(result.restaurant))
  end

  def destroy
    result = Delete::Restaurants.call(params: params)
    body(result, result.deleted_restaurant_ids)
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by(id: params[:id])
  end

  def menu_params
    params.permit(:id)
  end
end
