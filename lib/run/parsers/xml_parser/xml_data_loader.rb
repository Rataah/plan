module Plan
  # Load and parse XML config file
  class XMLDataLoader
    def self.parse(content, _)
      [].tap do |result|
        document = Nokogiri::XML(content)
        document.css('floor').each do |floor_node|
          result << XMLFloorFactory.parse_floor(floor_node)
        end
      end
    end
  end
end
