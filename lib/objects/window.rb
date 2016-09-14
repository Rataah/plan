module Plan
  class Window
    attr_accessor :origin, :length

    def initialize(origin, length)
      @origin = origin
      @length = length
    end

    def svg_elements(wall)
      Plan.log.debug("Draw SVG elements for Window of wall: #{wall.name}")
      window_a1 = wall.vertex_a1.translate(wall.angle, @origin)
      window_b1 = wall.vertex_b1.translate(wall.angle, @origin)
      window_a2 = window_a1.translate(wall.angle, @length)
      window_b2 = window_b1.translate(wall.angle, @length)

      [
          SVGPolygon.new([window_a1, window_b1, window_b2, window_a2]).fill('white').stroke('black'),
        SVGLine.new(wall.ab1.translate(wall.angle, @origin), wall.ab1.translate(wall.angle, @origin).translate(wall.angle, @length)).stroke('black')
      ]
    end
  end
end
