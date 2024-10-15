class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update]

  def index
    items = Item
      .order(:created_at)
      .paginate(page: params[:page], per_page: params[:per_page] || 30)

    json_pagination(
      items,
      ItemSerializer
    )
  rescue => e
    return json_error_response(e.message, :bad_request)
  end

  def show
    return json_error_response('not found') unless @item
    json_success_response(ItemSerializer.new(@item))
  end

  def create_or_update
    result = Create::Item.call(params: params)
    body(result, ItemSerializer.new(result.item))
  end

  def destroy
    result = Delete::Items.call(params: params)
    body(result, result.deleted_item_ids)
  end

  private

  def set_item
    @item = Item.find_by(id: params[:id])
  end

  def item_params
    params.permit(:id)
  end
end
