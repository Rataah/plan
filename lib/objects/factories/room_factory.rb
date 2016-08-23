module Plan
  class RoomFactory
    attr_reader :room

    def self.create(name, x = nil, y = nil, anchor: nil, &block)
      RoomFactory.new.instance_eval do
        @room = Room.new
        @room.origin = (anchor || Point.new(x, y)).dup
        @room.name = name

        if block
          @last_point = @room.origin
          instance_eval(&block)

          vertices = WallPool.walls(@room).map(&:vertices).flatten.uniq
          center = Plan.center(vertices)
          WallPool.walls(@room).map { |wall_link| wall_link.apply_width(center) }

          @room.center = center
          @room
        end
      end
    end

    def wall(wall_size, angle, width: DEFAULT_WALL_WIDTH, name: nil)
      new_wall = WallFactory.create(name ? name : "#{@room.name}_#{WallPool.walls(@room).size}", @last_point, wall_size, angle, width)
      @last_point = new_wall.a2
      WallPool.add_link(@room, new_wall, :a1, :a2)
      new_wall
    end
  end
end