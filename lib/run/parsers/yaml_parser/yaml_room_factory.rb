module Plan
  class YamlRoomFactory
    def self.parse_room(wall_pool, room_def)
      coordinates = room_def[:coordinates] || [nil, nil]
      anchor = if room_def.key?(:anchor)
                 DataLoader.retrieve_anchor(wall_pool, room_def[:anchor])
               else
                 Point.new(*coordinates)
               end

      # create a new Room
      RoomFactory.create(wall_pool, room_def[:name], nil, nil, anchor: anchor) do |room|
        last_point = anchor
        room_def[:walls].each_with_index do |wall_def, index|
          wall_name = wall_def[:name] ? wall_def[:name] : "#{room.name}_#{index}"

          new_wall = YamlWallFactory.parse_wall(wall_pool, wall_name, last_point, wall_def)
          wall_pool.add_link(room, new_wall, SegmentIndex.new(:a, 0), SegmentIndex.new(:a, 1), new_wall.angle)
          last_point = new_wall.a2
        end
      end
    end
  end
end
