module Plan
  class Point
    attr_reader :x, :y

    def initialize(x, y)
      @x = x.to_f
      @y = y.to_f
    end

    def add(x, y)
      Point.new(@x + x, @y + y)
    end

    def add!(x, y)
      @x += x
      @y += y
    end

    def translate(angle, length)
      add(length * Math.cos(angle), length * Math.sin(angle))
    end

    def round(digit)
      @x = @x.round(digit)
      @y = @y.round(digit)

      self
    end

    def dist(point = ZERO)
      Math.hypot(@x - point.x, @y - point.y)
    end

    def abs
      Point.new(@x.abs, @y.abs)
    end

    def xy
      [@x, @y]
    end

    def on_segment(a, b)
      dist(a) + dist(b) == a.dist(b)
    end

    def !=(other)
      @x != other.x || @y != other.y
    end

    def +(other)
      Point.new(@x + other.x, @y + other.y)
    end

    def -(other)
      Point.new(@x - other.x, @y - other.y)
    end

    def /(other)
      raise ZeroDivisionError if other.zero?
      Point.new(@x / other, @y / other)
    end

    def ==(other)
      eql?(other)
    end

    def to_s
      "#{@x}:#{@y}"
    end

    def to_svg
      %(#{@x},#{@y})
    end

    def hash
      xy.hash
    end

    def eql?(other)
      @x == other.x && @y == other.y
    end

    ZERO = Point.new(0, 0).freeze
  end
end
