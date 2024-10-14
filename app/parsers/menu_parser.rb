# frozen_string_literal: true

class MenuParser
  def initialize(params)
    @params = params
  end

  def run
   {
      name: @params[:name]
    }
  end
end
