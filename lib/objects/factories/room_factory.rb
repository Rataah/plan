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

          vertices = @room.walls.map { |wall| wall.room_vertices(@room) }.flatten.uniq
          center = Plan.center(vertices)
          @room.walls.each { |wall| wall.apply_width(center) }

          @room.center = center
          @room.walls = @room.walls
          @room
        end
      end
    end

    def wall(wall_size, angle, width: DEFAULT_WALL_WIDTH, name: nil)
      last_point = @room.walls.empty? ? @room.origin : @room.walls.last.AB2(@room)
      merged_walls, wall_to_remove = WallFactory.check_and_merge(@room, name, last_point, wall_size, angle, width)
      if merged_walls.any?
        Plan.log.debug("Room '#{@room.name}': wall(s) shared with '#{wall_to_remove.room_a.name}': #{name} => #{wall_to_remove.name}")

        linked_room = wall_to_remove.room_a
        linked_room.walls.delete(wall_to_remove)
        linked_room.walls.concat(merged_walls.select { |wall| wall.belongs_to? linked_room })
        linked_room.walls.each { |wall| wall.apply_width(linked_room.center) }

        new_walls = merged_walls.select { |wall| wall.belongs_to? @room }
        @room.walls.concat(new_walls)
        new_walls
      else
        (@room.walls << WallFactory.create(@room, name, last_point, wall_size, angle, width)).last
      end
    end
  end
end