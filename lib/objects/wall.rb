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
    include WallHelper

    attr_accessor :vertices_a, :vertices_b, :name, :angle, :length, :width, :rooms_coordinates, :windows, :doors

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
      @doors = []
      @rooms_coordinates = {}

      @angle = 0
      @name = 'wall'
      @width = 0
    end

    def ab1
      Plan.center(vertex_a1, vertex_b1)
    end

    def ab2
      Plan.center(vertex_a2, vertex_b2)
    end

    def vertices_center
      {}.tap do |vertices_indexed|
        @vertices_a.zip(@vertices_b).each_with_index do |vertices, index|
          vertices_indexed[Plan.center(vertices)] = [
            WallSegment.new(self, SegmentIndex.new(:a, index), SegmentIndex.new(:b, index), @angle)
          ]
        end
      end
    end

    def apply_width(vertices)
      return if @vertices_b.any?
      direction = angle + Plan.normal_angle(vertices, vertex_a1, vertex_a2, angle, false)
      @vertices_b << vertex_a1.translate(direction, @width).round(2)
      @vertices_b << vertex_a2.translate(direction, @width).round(2)
    end

    def vertices
      @vertices_a + @vertices_b.reverse
    end

    def filter_vertices(filters = [])
      side_filters = filters.group_by(&:side)
      side_filters.each_value { |value| value.map!(&:index) }

      @vertices_a.values_at(*side_filters[:a]) + @vertices_b.values_at(*side_filters[:b])
    end

    def bounds
      [a1, a2, b2, b1]
    end

    def translate(x, y)
      vertices.each { |vertex| vertex.add!(x, y) }
    end

    def svg_elements
      Plan.log.debug("Draw SVG elements for Wall: #{@name}")
      SVGGroup.new("wall_#{@name}").add do |group|
        group << SVGPolygon.new(vertices).css_class('wall')
        group << (@windows + @doors).map { |opening| opening.svg_elements(self) }
      end.comments(@name).merge!(self)
    end

    def to_s
      name
    end
  end
end
