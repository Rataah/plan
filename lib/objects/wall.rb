module Plan
  ANGLE_SHORTCUTS = {
    up: 270.0,
    down: 90.0,
    left: 180.0,
    right: 0.0
  }.freeze

  DEFAULT_WALL_WIDTH = 5

  # Represent a wall.
  class Wall < SVGArgument
    attr_accessor :vertices_a, :vertices_b, :name, :angle, :length, :width, :windows

    def vertex_a1
      @vertices_a.first
    end
    alias a1 vertex_a1
    def vertex_a2
      @vertices_a.last
    end
    alias a2 vertex_a2
    def vertex_b1
      @vertices_b.first
    end
    alias b1 vertex_b1
    def vertex_b2
      @vertices_b.last
    end
    alias b2 vertex_b2

    def initialize
      super
      @vertices_a = []
      @vertices_b = []
      @windows = []
    end

    def ab1
      Plan.center([vertex_a1, vertex_b1])
    end

    def ab2
      Plan.center([vertex_a2, vertex_b2])
    end

    def vertices_center
      {}.tap do |vertices_indexed|
        @vertices_a.each_with_index do |v_a, index|
          vertices_center = Plan.center([v_a, @vertices_b[index]])
          vertices_indexed[vertices_center] = [
            WallSegment.new(self, SegmentIndex.new(:a, index), SegmentIndex.new(:b, index), @angle)
          ]
        end
      end
    end

    def initialized?
      @vertices_b.any?
    end

    def apply_width(ref_point)
      return if initialized?
      direction = @angle + (-90.0 * Plan.position_against(ref_point, vertex_a1, vertex_a2)).rad
      @vertices_b << vertex_a1.translate(direction, @width).round(2)
      @vertices_b << vertex_a2.translate(direction, @width).round(2)
    end

    def vertices(filters = [])
      return @vertices_a + @vertices_b.reverse if filters.empty?

      @vertices_a.values_at(*filters.select(&:a?).map(&:index)) +
        @vertices_b.values_at(*filters.select(&:b?).map(&:index))
    end

    def translate(x, y)
      vertices.each { |vertex| vertex.add!(x, y) }
    end

    def svg_elements
      Plan.log.debug("Draw SVG elements for Wall: #{@name}")
      SVGGroup.new(@name.to_id) do |group|
        group.add SVGPolygon.new(vertices).fill('gray').stroke('black').comments(@name).merge!(self)
        group.add @windows.map { |window| window.svg_elements(self) }
      end
    end

    def aligned?(other)
      Plan.angle_aligned?(@angle, other.angle)
    end

    def intersect?(other)
      [ab1, ab2].count { |vertex| vertex.on_segment(other.ab1, other.ab2) }.nonzero?
    end
  end
end
