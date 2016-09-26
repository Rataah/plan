module Plan
  # Load and parse Ruby config file
  class RubyDataLoader
    def self.load_data_from_file(filename)
      parse(File.read(filename, encoding: 'BOM|UTF-8', mode: 'rb'), filename)
    end

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

      def room(*args, &block)
        if args.last.is_a?(Hash) && args.last.key?(:anchor)
          args.last[:anchor] = retrieve_anchor(args.last[:anchor])
        end

        @data << RoomFactory.create(*args, &block)
      end

      private

      def retrieve_anchor(anchor)
        anchor_name, _, anchor_point = anchor.rpartition('.')
        raise "Anchor #{anchor_name} not found" unless WallPool.contains? anchor_name
        raise 'Incorrect anchor point' unless %w(a1 a2 b1 b2).include? anchor_point

        WallPool[anchor_name].send(anchor_point.to_sym)
      end
    end
  end
end
