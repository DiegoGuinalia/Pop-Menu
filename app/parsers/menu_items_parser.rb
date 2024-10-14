# frozen_string_literal: true

class MenuItemsParser
  def initialize(params)
    @params = params
  end

  def run
   {
      price: @params[:price]
    }
  end
end
