module Plan
  class XMLFloorFactory
    def self.parse_floor(floor_node)
      # create a new Floor
      FloorFactory.create(floor_node['name']) do |floor|
        floor_node.css('room').each do |room_node|
          floor.rooms << XMLRoomFactory.parse_room(floor.wall_pool, room_node)
        end
      end
    end
  end
end
