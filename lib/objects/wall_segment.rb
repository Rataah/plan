module Plan
  # Represent a single point on a wall. Two SegmentIndex are needed to build a WallSegment
  class SegmentIndex
    attr_accessor :side, :index

    def initialize(side, index)
      @side = side
      @index = index
    end

    def a?
      @side == :a
    end

    def b?
      @side == :b
    end

    def other_side
      SegmentIndex.new(a? ? :b : :a, @index)
    end
  end

  # Represent the link between a room and a wall
  class WallSegment
    attr_accessor :wall, :vertex1, :vertex2, :angle

    def initialize(wall, vertex1, vertex2, angle)
      @wall = wall
      @vertex1 = vertex1
      @vertex2 = vertex2
      @angle = angle
    end

    def vertices
      @wall.filter_vertices [@vertex1, @vertex2]
    end

    def centers
      [].tap do |center_points|
        @wall.filter_vertices([@vertex1, @vertex2]).zip(
          @wall.filter_vertices([@vertex1.other_side, @vertex2.other_side])
        ) do |points|
          center_points << Plan.center(points)
        end
      end
    end

    def distance
      segment = vertices
      segment.first.dist segment.last
    end

    def apply_width(direction)
      @wall.apply_width(direction)
    end

    def svg_elements
      SVGTools.dimensions(Plan.id(WallSegment), vertices, @wall.vertices, @wall.angle, @wall.width + 20)
    end
  end
end
