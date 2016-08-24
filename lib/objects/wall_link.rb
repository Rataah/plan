module Plan
  class WallFilter
    attr_accessor :side, :index

    def initialize(side, index)
      @side = side
      @index = index
    end

    def a?; @side == :a end
    def b?; @side == :b end
  end

  class WallLink
    attr_accessor :wall, :vertex1, :vertex2

    def initialize(wall, vertex1, vertex2)
      @wall = wall
      @vertex1 = vertex1
      @vertex2 = vertex2
    end

    def vertices
      @wall.vertices [@vertex1, @vertex2]
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