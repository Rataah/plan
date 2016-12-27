module Plan
  class YamlRoomFactory
    def self.parse_room(room_def)
      coordinates = room_def[:coordinates] || [nil, nil]
      anchor = room_def.key?(:anchor) ? DataLoader.retrieve_anchor(room_def[:anchor]) : Point.new(*coordinates)

      # create a new Room
      RoomFactory.create(room_def[:name], nil, nil, anchor: anchor) do |room|
        last_point = anchor
        room_def[:walls].each_with_index do |wall_def, index|
          wall_name = wall_def[:name] ? wall_def[:name] : "#{room.name}_#{index}"

          new_wall = YamlWallFactory.parse_wall(wall_name, last_point, wall_def)
          WallPool.add_link(room, new_wall, SegmentIndex.new(:a, 0), SegmentIndex.new(:a, 1), new_wall.angle)
          last_point = new_wall.a2
        end
      end
    end
  end
end
