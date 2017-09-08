module Plan
  # Load and parse Ruby config file
  class RubyDataLoader
    def self.parse(content, filename)
      DataLoaded.new.tap do |result|
        DataParser.new(result).instance_eval(content, filename)
      end
    end

    # Parse the data. A ruby config file is evaluated on the DataParser instance
    class DataParser
      def initialize(result)
        @floor_factory = FloorFactory.new
        @data = result
      end

      def floor(*args, &block)
        @data.elements << @floor_factory.create(*args, &block)
      end

      def metadata(*args, &block)
        @data.metadata = MetadataFactory.create(*args, &block)
      end
    end
  end
end
