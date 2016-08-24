module Plan
  class SegmentIndex
    attr_accessor :side, :index

    def initialize(side, index)
      @side = side
      @index = index
    end

    def a?; @side == :a end
    def b?; @side == :b end

    def other_side
      SegmentIndex.new(a? ? :b : :a, @index)
    end
  end

  class WallSegment
    attr_accessor :wall, :vertex1, :vertex2

    def initialize(wall, vertex1, vertex2)
      @wall = wall
      @vertex1 = vertex1
      @vertex2 = vertex2
    end

    def vertices
      @wall.vertices [@vertex1, @vertex2]
    end

    def centers
      [].tap do |center_points|
        @wall.vertices([@vertex1, @vertex2]).zip @wall.vertices([@vertex1.other_side, @vertex2.other_side]) do |points|
          center_points << Plan.center(points)
        end
      end
    end

    def distance
      segment = vertices
      segment.first.dist segment.last
    end

    def apply_width(ref_point)
      @wall.apply_width(ref_point)
    end
  end
end