module Plan
  class XMLDataLoader
    def self.parse(content, _)
      [].tap do |result|
        document = Nokogiri::XML(content)
        document.css('room').each do |room_node|
          result << XMLRoomFactory.parse_room(room_node)
        end
      end
    end
  end
end
