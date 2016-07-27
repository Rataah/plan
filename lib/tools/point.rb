module Plan
  def self.bounds(points)
    min_x = points.min_by(&:x).x
    min_y = points.min_by(&:y).y
    max_x = points.max_by(&:x).x
    max_y = points.max_by(&:y).y
    [Point.new(min_x, min_y), Point.new(max_x, max_y)]
  end

  class Point
    attr_accessor :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def add(x, y)
      Point.new(@x + x, @y + y)
    end

    def add!(x, y)
      @x += x
      @y += y
    end
    alias translate add!

    def round(digit)
      @x = @x.round(digit)
      @y = @y.round(digit)

      self
    end

    def dist(point)
      Math.hypot(@x - point.x, @y - point.y)
    end

    def xy
      [@x, @y]
    end

    def !=(point)
      @x != point.x || @y != point.y
    end

    def -(point)
      Point.new(@x - point.x, @y - point.y)
    end
  end
end
