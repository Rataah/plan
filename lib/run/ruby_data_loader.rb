module Plan
  class RubyDataLoader

    def self.load_data_from_file(filename)
      parse( File.read(filename, encoding: "BOM|UTF-8", mode: 'rb'), filename )
    end

    def self.parse(content, filename)
      result = []
      DataParser.new(result).instance_eval(content, filename)
      result
    end

    class DataParser
      def initialize(result)
        @data = result
      end

      def store(data)
        @data << data
      end
    end
  end
end