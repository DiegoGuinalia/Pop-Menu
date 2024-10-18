module FileUpload
  class Base
    include Interactor
    include Utils

    def call
      raise 'File not provided' unless context.file.present?

      context.unprocessed_items = []

      raw_data = read_file
      parsed_data = parse(raw_data)
      cleaned_data = clean_data(parsed_data)
      process_data(cleaned_data)
    rescue StandardError => e
      Rails.logger.error("Failed to process: #{e.class.name} - #{e.message}")
      Rails.logger.error(e)
      context.fail!(error: "unexpected error has occurred")
    end

    private

    def read_file
      File.read(context.file.tempfile)
    end

    def parse(raw_data)
      raise NotImplementedError, 'Subclasses must implement the parse method'
    end

    def process_data(parsed_data)
      ProcessData::RestaurantUpload.call(params: parsed_data)
    end

    def clean_data(data)
      regex = /^[\p{L}\p{M}\s&']+$/u

      def valid_price?(price)
        begin
          Float(price) > 0
        rescue ArgumentError
          false
        end
      end

      data.map do |menu|
        valid_name = menu[:name].match?(regex)
        valid_restaurant_name = menu[:restaurant_name].match?(regex)

        unprocessed_menu_items = menu[:menu_items].reject do |item|
          item[:name].match?(regex) && valid_price?(item[:price])
        end

        unless unprocessed_menu_items.empty?
          context.unprocessed_items << { menu_items: unprocessed_menu_items }
        end

        filtered_menu_items = menu[:menu_items].select do |item|
          item[:name].match?(regex) && valid_price?(item[:price])
        end

        unless valid_name && valid_restaurant_name
          context.unprocessed_items << { menu: { name: menu[:name], restaurant_name: menu[:restaurant_name], menu_items: filtered_menu_items } }
        end

        if valid_name && valid_restaurant_name
          menu.merge(menu_items: filtered_menu_items)
        end
      end.compact
    end
  end
end
