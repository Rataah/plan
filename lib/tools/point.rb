module Plan
  class Point
    attr_reader :coord_x, :coord_y

    alias x coord_x
    alias y coord_y

    def initialize(coord_x, coord_y)
      @coord_x = coord_x.to_f
      @coord_y = coord_y.to_f
    end

    def add(amount_x, amount_y)
      Point.new(@coord_x + amount_x, @coord_y + amount_y)
    end

    def add!(amount_x, amount_y)
      @coord_x += amount_x
      @coord_y += amount_y
    end

    def translate(angle, length)
      add(length * Math.cos(angle), length * Math.sin(angle)).round(2)
    end

    def round(digit)
      @coord_x = @coord_x.round(digit)
      @coord_y = @coord_y.round(digit)

      self
    end

    def dist(point = ZERO)
      Math.hypot(@coord_x - point.x, @coord_y - point.y)
    end

    def abs
      Point.new(@coord_x.abs, @coord_y.abs)
    end

    def -@
      Point.new(-@coord_x, -@coord_y)
    end

    def xy
      [@coord_x, @coord_y]
    end

    def on_segment(point_a, point_b)
      dist(point_a) + dist(point_b) == point_a.dist(point_b)
    end

    def orientation(cos_angle, sin_angle)
      @coord_x * cos_angle - @coord_y * sin_angle
    end

    def !=(other)
      @coord_x != other.x || @coord_y != other.y
    end

    def +(other)
      Point.new(@coord_x + other.x, @coord_y + other.y)
    end

    def -(other)
      Point.new(@coord_x - other.x, @coord_y - other.y)
    end

    def /(other)
      raise ZeroDivisionError if other.zero?
      Point.new(@coord_x / other, @coord_y / other)
    end

    def norm
      Point.new(@coord_x / dist, @coord_y / dist)
    end

    def angle_with(other)
      Math.atan2(other.y - coord_y, other.x - coord_x)
    end

    def ==(other)
      eql?(other)
    end

    def to_s
      "#{@coord_x}:#{@coord_y}"
    end

    def to_svg
      %(#{@coord_x},#{@coord_y})
    end

    def hash
      xy.hash
    end

    def eql?(other)
      @coord_x == other.x && @coord_y == other.y
    end

    ZERO = Point.new(0, 0).freeze
  end
end
