# app/interactors/process/restaurant_upload.rb
module ProcessData
  class RestaurantUpload
    include Interactor

    delegate :params, to: :context

    def call
      context.process_result = []
      params.map do |restaurant_params|
        result = PlaceMenus.call(params: restaurant_params)
        if result.success?
          context.process_result << result
        else
          context.fail!(error: "Error processing restaurant: #{result.error}")
        end
      end
    end
  end
end
