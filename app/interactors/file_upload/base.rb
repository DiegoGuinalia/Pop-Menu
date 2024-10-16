module FileUpload
  class Base
    include Interactor
    include Utils

    def call
      raise 'File not provided' unless context.file.present?

      raw_data = read_file
      parsed_data = parse(raw_data)
      process_data(parsed_data)
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
  end
end
