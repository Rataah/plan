module Plan
  ANGLE_SHORTCUTS = {
      up: 270.0,
      down: 90.0,
      left: 180.0,
      right: 0.0
  }

  DEFAULT_WALL_WIDTH = 2.freeze

  class Wall < SVGArgument
    attr_accessor :vertices_a, :vertices_b, :name, :angle, :length, :width

    def vertex_a1; @vertices_a.first end
    alias_method :a1, :vertex_a1
    def vertex_a2; @vertices_a.last end
    alias_method :a2, :vertex_a2
    def vertex_b1; @vertices_b.first end
    alias_method :b1, :vertex_b1
    def vertex_b2; @vertices_b.last end
    alias_method :b2, :vertex_b2

    def initialize
      super
      @vertices_a = []
      @vertices_b = []
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
          vertices_indexed[vertices_center] = [WallSegment.new(self, SegmentIndex.new(:a, index), SegmentIndex.new(:b, index))]
        end
      end
    end

    def initialized?
      @vertices_b.any?
    end

    def apply_width(ref_point)
      return if initialized?
      direction = -90.0 * (((vertex_a2.x - vertex_a1.x) * (ref_point.y - vertex_a1.y) - (vertex_a2.y - vertex_a1.y) * (ref_point.x - vertex_a1.x)) <=> 0.0)
      @vertices_b << vertex_a1.add(@width * Math.cos(@angle + direction.rad), @width * Math.sin(@angle + direction.rad)).round(2)
      @vertices_b << vertex_a2.add(@width * Math.cos(@angle + direction.rad), @width * Math.sin(@angle + direction.rad)).round(2)
    end

    def vertices(filters = [])
      return @vertices_a + @vertices_b.reverse if filters.empty?

      @vertices_a.values_at(*filters.select(&:a?).map(&:index)) + @vertices_b.values_at(*filters.select(&:b?).map(&:index))
    end

    def translate(x, y)
      vertices.each { |vertex| vertex.translate(x, y) }
    end

    def svg_elements
      Plan.log.debug("Draw SVG elements for Wall: #{@name}")
      [SVGPolygon.new(vertices).fill('white').stroke('black').comments(@name).merge!(self),
       SVGLine.new(*[ab1.xy, ab2.xy].flatten).stroke('red')]
    end
  end
end