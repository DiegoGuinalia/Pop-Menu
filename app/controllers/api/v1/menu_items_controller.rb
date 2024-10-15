class Api::V1::MenuItemsController < ApplicationController
  before_action :set_menu_item, only: %i[show update]

  def index
    menu_items = MenuItem
      .order(:created_at)
      .paginate(page: params[:page], per_page: params[:per_page] || 30)

    json_pagination(
      menu_items,
      MenuItemSerializer
    )
  rescue => e
    return json_error_response(e.message, :bad_request)
  end

  def show
    return json_error_response('not found') unless @menu_item
    json_success_response(MenuItemSerializer.new(@menu_item))
  end

  def destroy
    result = Delete::MenuItems.call(params: params)
    body(result, result.deleted_menu_item_ids)
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find_by(id: params[:id])
  end

  def menu_params
    params.permit(:id)
  end
end
