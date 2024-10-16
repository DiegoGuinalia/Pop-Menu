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
      result = MenuCreateContract.new.call(unsafe_hash)
      context.fail!(error: result.errors.to_h) unless result.success?
    end

    def unsafe_hash
      return params if params.is_a?(Hash)
      params.to_unsafe_h
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
