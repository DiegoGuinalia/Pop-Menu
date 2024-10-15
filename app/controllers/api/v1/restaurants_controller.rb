class Api::V1::RestaurantsController < ApplicationController
  def index
    restaurant = Restaurant
      .order(:created_at)
      .paginate(page: params[:page], per_page: params[:per_page] || 30)

    json_pagination(
      restaurant,
      RestaurantSerializer
    )
  rescue => e
    json_error_response(e.message, :bad_request)
  end

  def show
    restaurant = Restaurant.find_by(id: params[:id])

    return json_error_response('not found') unless restaurant
    json_success_response(RestaurantSerializer.new(restaurant))
  end

  def create_or_update
    result = Create::Restaurant.call(params: params)
    body(result, RestaurantSerializer.new(result.restaurant))
  end

  def destroy
    result = Delete::Restaurants.call(params: params)
    body(result, result.deleted_restaurant_ids)
  end

  def upload
    if params[:file].present?
      json_data = File.read(params[:file].tempfile)
      data_to_parse = JSON.parse(json_data, symbolize_names: true)
      parsed_data = JsonDataParser.new(data_to_parse).run
      result = ProcessData::RestaurantUpload.call(params: parsed_data)

      if result.success?
        body(result, 'ok')
      else
        json_error_response('Unable to process data', :unprocessable_entity)
      end
    else
      json_error_response('File not found', :unprocessable_entity)
    end
  end

  private

  def menu_params
    params.permit(:id)
  end
end
