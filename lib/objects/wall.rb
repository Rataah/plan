module Plan
  ANGLE_SHORTCUTS = {
      up: 270.0,
      down: 90.0,
      left: 180.0,
      right: 0.0
  }

  DEFAULT_WALL_WIDTH = 2.freeze

  class Wall < SVGArgument
    attr_accessor :vertex_a1, :vertex_a2, :vertex_b1, :vertex_b2, :name, :angle, :length, :width
    alias_method :a1, :vertex_a1
    alias_method :a2, :vertex_a2
    alias_method :b1, :vertex_b1
    alias_method :b2, :vertex_b2

    def ab1
      Plan.center([@vertex_a1, @vertex_b1])
    end

    def ab2
      Plan.center([@vertex_a2, @vertex_b2])
    end

    def initialized?
      @vertex_b1 && @vertex_b2
    end

    def apply_width(ref_point)
      return if initialized?
      direction = -90.0 * (((@vertex_a2.x - @vertex_a1.x) * (ref_point.y - @vertex_a1.y) - (@vertex_a2.y - @vertex_a1.y) * (ref_point.x - @vertex_a1.x)) <=> 0.0)
      @vertex_b1 = @vertex_a1.add(@width * Math.cos(@angle + direction.rad), @width * Math.sin(@angle + direction.rad)).round(2)
      @vertex_b2 = @vertex_a2.add(@width * Math.cos(@angle + direction.rad), @width * Math.sin(@angle + direction.rad)).round(2)
    end

    def vertices(filters = nil)
      @vertices = { a1: @vertex_a1, a2: @vertex_a2, b2: @vertex_b2, b1: @vertex_b1 }
      return @vertices.values if filters.nil?

      filters.map { |filter| @vertices[filter] }
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