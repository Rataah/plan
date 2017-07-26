module Plan
  class YamlFloorFactory
    def self.parse_floor(floor_def)
      # create a new Floor
      FloorFactory.create(floor_def[:name]) do |floor|
        floor_def[:rooms].each do |room_def|
          floor.rooms << YamlRoomFactory.parse_room(floor.wall_pool, room_def)
        end
      end
    end
  end
end
