module Plan
  class ParserError < StandardError
  end

  class DataLoader
    def self.load(filename)
      Plan.log.info("Loading configuration from #{filename}")
      content = load_data_from_file(filename)

      RubyDataLoader.parse(content, filename)
    end

    def self.load_data_from_file(filename)
      File.read(filename, encoding: 'BOM|UTF-8', mode: 'rb')
    end

    def self.retrieve_anchor(wall_pool, anchor)
      anchor_name, _, anchor_point = anchor.rpartition('.')
      raise "Anchor #{anchor_name} not found" unless wall_pool.contains? anchor_name
      raise 'Incorrect anchor point' unless %w[a1 a2 b1 b2].include? anchor_point
      wall_pool[anchor_name].send(anchor_point.to_sym)
    end
  end
end
