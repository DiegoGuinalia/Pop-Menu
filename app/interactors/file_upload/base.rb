module FileUpload
  class Base
    include Interactor
    include Utils

    def call
      raise 'File not provided' unless context.file.present?

      context.unprocessed_items = []
      context.processed_items = []

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

      data.each do |menu|
        unprocessed_menu_items = menu[:menu_items].reject do |item|
          item[:name].match?(regex) && valid_price?(item[:price])
        end

        context.unprocessed_items.concat(unprocessed_menu_items) unless unprocessed_menu_items.empty?

        unique_menu_items = {}

        menu[:menu_items].each do |item|
          if item[:name].match?(regex) && valid_price?(item[:price])
            unique_menu_items[item[:price]] ||= item
          end
        end

        processed_menu_items = unique_menu_items.values

        unless processed_menu_items.empty?
          context.processed_items << { menu_items: processed_menu_items }
        end
      end
    end
  end
end
