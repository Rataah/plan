module Plan
  # Room factory. Create a room and manage his walls (with WallSegment)
  class RoomFactory
    attr_reader :room

    def self.create(name, x = nil, y = nil, anchor: Point.new(x, y), &block)
      RoomFactory.new.instance_eval do
        @room = Room.new(name, anchor.dup)
        @last_point = @room.origin

        instance_exec(@room, &block)

        vertices = WallPool.walls(@room).map(&:vertices).flatten.uniq
        @room.center = Plan.center(vertices)
        WallPool.walls(@room).map { |wall_link| wall_link.apply_width(@room.vertices) }
        @room
      end
    end

    def wall(wall_size, angle, width: DEFAULT_WALL_WIDTH, name: nil, &block)
      new_wall = WallFactory.create(name ? name : "#{@room.name}_#{WallPool.walls(@room).size}",
                                    @last_point, wall_size, angle, width, &block)
      @last_point = new_wall.a2
      WallPool.add_link(@room, new_wall, SegmentIndex.new(:a, 0), SegmentIndex.new(:a, 1), new_wall.angle)
      new_wall
    end
  end
end
