module Plan
  # Room factory. Create a room and manage his walls (with WallSegment)
  class RoomFactory
    attr_reader :room

    def self.create(wall_pool, name, x = nil, y = nil, anchor: Point.new(x, y), &block)
      RoomFactory.new(wall_pool).instance_eval do
        @room = Room.new(@wall_pool, name, anchor.dup)
        @last_point = @room.origin

        instance_exec(@room, &block)

        vertices = @wall_pool.walls(@room).map(&:vertices).flatten.uniq
        @room.center = Plan.center(vertices)
        @wall_pool.walls(@room).map { |wall_link| wall_link.apply_width(@room.vertices) }
        @wall_pool.walls(@room).each { |wall_link| wall_link.add_rooms_coordinates(@room) }

        @room
      end
    end

    def initialize(wall_pool)
      @wall_pool = wall_pool
    end

    def wall(wall_size, angle, width: DEFAULT_WALL_WIDTH, name: nil, &block)
      new_wall = WallFactory.create(
        @room,
        @wall_pool,
        name ? name : "#{@room.name}_#{@wall_pool.walls(@room).size}",
        @last_point,
        wall_size,
        angle,
        width,
        &block
      )

      @last_point = new_wall.a2
      @wall_pool.add_link(@room, new_wall, SegmentIndex.new(:a, 0), SegmentIndex.new(:a, 1), new_wall.angle)
      new_wall
    end
  end
end
