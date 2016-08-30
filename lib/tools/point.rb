# Non standard operation on a Point
module Plan
  def self.bounds(points)
    min_x = points.min_by(&:x).x
    min_y = points.min_by(&:y).y
    max_x = points.max_by(&:x).x
    max_y = points.max_by(&:y).y
    [Point.new(min_x, min_y), Point.new(max_x, max_y)]
  end

  def self.center(points)
    Plan.bounds(points).reduce(&:+) / 2
  end

  def self.position_against(point, segment_a, segment_b)
    segment = segment_b - segment_a
    (segment.x * (point.y - segment_a.y) -
      segment.y * (point.x - segment_b.x)) <=> 0.0
  end

  def self.angle_aligned?(first_angle, second_angle)
    first_angle == second_angle || (first_angle + Math::PI) % (2 * Math::PI) == second_angle
  end

  # Represent a point
  class Point
    attr_reader :x, :y

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
      Point.new(@x / other, @y / other)
    end

    def >=(other)
      dist(ZERO) >= other.dist(ZERO)
    end

    def <=(other)
      dist(ZERO) <= other.dist(ZERO)
    end

    def ==(other)
      eql?(other)
    end

    def to_s
      "#{@x}:#{@y}"
    end

    def hash
      [@x, @y].hash
    end

    def eql?(other)
      @x == other.x && @y == other.y
    end

    ZERO = Point.new(0, 0).freeze
  end
end
