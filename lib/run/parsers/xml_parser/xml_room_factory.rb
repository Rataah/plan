module Plan
  class XMLRoomFactory
    def self.parse_room(room_node)
      coordinates = (room_node['coordinates'].split(':') || [nil, nil]).map(&:to_f)
      anchor = room_node.key?('anchor') ? DataLoader.retrieve_anchor(room_node['anchor']) : Point.new(*coordinates)

      # create a new Room
      RoomFactory.create(room_node['name'], nil, nil, anchor: anchor) do |room|
        last_point = anchor
        room_node.css('wall').each_with_index do |wall_node, index|
          wall_name = wall_node['name'] ? wall_node['name'] : "#{room.name}_#{index}"

          new_wall = XMLWallFactory.parse_wall(wall_name, last_point, wall_node)
          WallPool.add_link(room, new_wall, SegmentIndex.new(:a, 0), SegmentIndex.new(:a, 1), new_wall.angle)
          last_point = new_wall.a2
        end
      end
    end
  end
end
