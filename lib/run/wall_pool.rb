module Plan
  # Pool of wall. Handle the links between a room and a wall with a wall segment
  class WallPool
    def self.create_and_store
      wall = Wall.new
      yield wall if block_given?

      WallPool.pool[wall.name] = wall if wall.name
      wall
    end

    def self.contains?(wall_name)
      WallPool.pool.key? wall_name
    end

    def self.[](wall_name)
      WallPool.pool[wall_name]
    end

    def self.all
      WallPool.pool.values
    end

    def self.without(wall)
      WallPool.pool.values.select { |other_wall| other_wall != wall }
    end

    def self.delete(*wall_names)
      WallPool.pool.delete_if { |name| wall_names.include? name }
    end

    def self.each
      WallPool.pool.each_value do |value|
        yield value
      end
    end

    def self.add_link(room, wall, vertex1, vertex2, angle)
      WallPool.link[room] ||= []
      WallPool.link[room] << WallSegment.new(wall, vertex1, vertex2, angle)
    end

    def self.walls(room)
      WallPool.link[room] ||= []
    end

    def self.replace_segment(room, old_wall_segment, new_segment)
      WallPool.link[room].map! { |wall_segment| wall_segment == old_wall_segment ? new_segment : wall_segment }
    end

    def self.rooms(*walls)
      WallPool.link.select do |_, wall_segments|
        wall_segments.count { |wall_segment| walls.include? wall_segment.wall } > 0
      end.keys
    end

    def self.segments(room, *walls)
      walls(room).select { |wall_segment| walls.include? wall_segment.wall }
    end

    def self.wall_at_position(point)
      WallPool.all.select do |wall|
        Plan.point_in_polygon?(point, wall.bounds)
      end.first
    end

    private_class_method

    def self.pool
      @wall_pool ||= {}
    end

    def self.link
      @wall_link ||= {}
    end
  end
end
