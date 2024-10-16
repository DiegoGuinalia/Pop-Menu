module FileUpload
  class Json < Base
    private

    def parse(raw_data)
      data_to_parse = JSON.parse(raw_data, symbolize_names: true)
      JsonDataParser.new(data_to_parse).run
    end
  end
end
