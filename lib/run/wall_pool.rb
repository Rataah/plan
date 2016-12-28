module Plan
  # Pool of wall. Handle the links between a room and a wall with a wall segment
  class WallPool
    def create_and_store
      wall = Wall.new
      yield wall if block_given?

      pool[wall.name] = wall if wall.name
      wall
    end

    def contains?(wall_name)
      pool.key? wall_name
    end

    def [](wall_name)
      pool[wall_name]
    end

    def all
      pool.values
    end

    def without(wall)
      pool.values.select { |other_wall| other_wall != wall }
    end

    def delete(*wall_names)
      pool.delete_if { |name| wall_names.include? name }
    end

    def each
      pool.each_value do |value|
        yield value
      end
    end

    def add_link(room, wall, vertex1, vertex2, angle)
      link[room] ||= []
      link[room] << WallSegment.new(wall, vertex1, vertex2, angle)
    end

    def walls(room)
      link[room] ||= []
    end

    def replace_segment(room, old_wall_segment, new_segment)
      link[room].map! { |wall_segment| wall_segment == old_wall_segment ? new_segment : wall_segment }
    end

    def rooms(*walls)
      link.select do |_, wall_segments|
        wall_segments.count { |wall_segment| walls.include? wall_segment.wall } > 0
      end.keys
    end

    def segments(room, *walls)
      walls(room).select { |wall_segment| walls.include? wall_segment.wall }
    end

    def wall_at_position(point)
      all.select do |wall|
        Plan.point_in_polygon?(point, wall.bounds)
      end.first
    end

    private_class_method

    def self.[](floor)
      @pools ||= {}

      unless @pools.key?(floor)
        Plan.log.debug("New wall pool for floor #{floor.name}")
        @pools[floor] = WallPool.new(floor)
      end
      @pools[floor]
    end

    private

    def initialize(floor)
      @floor = floor
    end

    def pool
      @wall_pool ||= {}
    end

    def link
      @wall_link ||= {}
    end
  end
end
