class Api::V1::MenusController < ApplicationController
  before_action :set_menu, only: %i[show update]

  def index
    menus = Menu
      .order(:created_at)
      .paginate(page: params[:page], per_page: params[:per_page] || 30)

    json_pagination(
      menus,
      MenuSerializer
    )
  rescue => e
    return json_error_response(e.message, :bad_request)
  end

  def show
    return json_error_response('not found') unless @menu
    json_success_response(MenuSerializer.new(@menu))
  end

  def create_or_update
    result = PlaceMenus.call(params: params)
    body(result, MenuSerializer.new(result.menu))
  end

  def destroy
    result = Delete::Menus.call(params: params)
    body(result, result.proccessed_menu_ids)
  end

  private

  def set_menu
    @menu = Menu.find_by(id: params[:id])
  end

  def menu_params
    params.permit(:id)
  end
end
