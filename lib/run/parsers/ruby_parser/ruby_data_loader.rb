module Plan
  # Load and parse Ruby config file
  class RubyDataLoader
    def self.parse(content, filename)
      [].tap do |result|
        DataParser.new(result).instance_eval(content, filename)
      end
    end

    # Parse the data. A ruby config file is evaluated on the DataParser instance
    class DataParser
      def initialize(result)
        @data = result
      end

      def floor(*args, &block)
        @data << FloorFactory.create(*args, &block)
      end
    end
  end
end
