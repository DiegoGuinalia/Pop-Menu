module Parse
  class MenuData
    include Interactor

    delegate :params, to: :context

    def call
      validate
      parse_data
    end

    private

    def validate
      result = MenuCreateContract.new.call(params.to_unsafe_h)
      context.fail!(error: result.errors.to_h) unless result.success?
    end

    def parse_data
      menu_context
    end

    def menu_context
      menu_parser = MenuParser.new(context.params)
      context.menu_data = menu_parser.run
    end
  end
end
