module Plan
  class RoomFactory
    attr_reader :room

    def self.create(name, x = nil, y = nil, anchor: nil, &block)
      RoomFactory.new.instance_eval do
        @room = Room.new
        @room.walls = []
        @room.origin = (anchor || Point.new(x, y)).dup
        @room.name = name

        if block
          instance_eval(&block)

          if @room.walls.first.AB1(self) != @room.walls.last.AB2(self)
            Plan.log.debug("Room '#{name}': connect last wall to the first")
            @room.walls << Wall.connect(self, "#{@room.name}_last", @room.walls.last, @room.walls.first, DEFAULT_WALL_WIDTH)
          end

          vertices = @room.walls.map { |wall| wall.room_vertices(@room) }.flatten.uniq

          min_x = vertices.min_by(&:x).x
          max_x = vertices.max_by(&:x).x
          min_y = vertices.min_by(&:y).y
          max_y = vertices.max_by(&:y).y

          center = Point.new(min_x + (max_x - min_x)/2.0, min_y + (max_y - min_y)/2.0)
          @room.walls.each { |wall| wall.apply_width(center) }

          @room.center = center
          @room.walls = @room.walls
          @room
        end
      end
    end

    def wall(wall_size, angle, width: DEFAULT_WALL_WIDTH, name: nil)
      last_point = @room.walls.empty? ? @room.origin : @room.walls.last.AB2(@room)
      WallFactory.check_and_merge(@room, name, last_point, wall_size, angle, width)

      @room.walls << WallFactory.create(@room, name, last_point, wall_size, angle, width)
      @room.walls.last
    end
  end
end