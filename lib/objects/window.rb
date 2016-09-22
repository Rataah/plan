module Plan
  class Window
    Wing = Struct.new(:origin, :length, :angle, :reverse, :side)

    attr_accessor :origin, :length

    def initialize(origin, length)
      @origin = origin
      @length = length

      @wings = []
    end

    def wing(length, reverse: false, origin: nil, angle: Math::PI / 2.0, outside: false)
      origin ||= @wings.any? ? @wings.last.origin + @wings.last.length : 0

      origin += length if reverse
      reverse = reverse ? -1.0 : 1.0
      side = outside ? -1.0 : 1.0

      @wings << Wing.new(origin, length * reverse, angle * reverse, reverse, side)
      self
    end

    def svg_elements(wall)
      Plan.log.debug("Draw SVG elements for Window of wall: #{wall.name}")
      window_a1 = wall.vertex_a1.translate(wall.angle, @origin)
      window_b1 = wall.vertex_b1.translate(wall.angle, @origin)
      window_a2 = window_a1.translate(wall.angle, @length)
      window_b2 = window_b1.translate(wall.angle, @length)

      window_center = wall.ab1.translate(wall.angle, @origin)
      SVGGroup.new("window_#{object_id}").add([].tap do |group|
        group << SVGPolygon.new([window_a1, window_b1, window_b2, window_a2]).fill('white').stroke('black')
        group << SVGLine.new(window_center, window_center.translate(wall.angle, @length)).stroke('black')
        group.push(@wings.map { |wing| wing_svg_element(wall.angle, wing, window_center) })
      end).css_class('window')
    end

    def wing_svg_element(angle, wing, window_anchor)
      angle *= wing.reverse
      wing_origin = window_anchor.translate(angle, wing.origin)
      wing_angle = angle.rotate_rad(wing.angle * wing.side)
      sweep_flag = if wing.reverse.positive?
                     1
                   else
                     wing.side.positive? ? 0 : 1
                   end

      SVGPath.new(wing_origin).line_to(wing_origin.translate(angle, wing.length)).arc(
        Point.new(wing.length.abs, wing.length.abs),
        wing_origin.translate(wing_angle, wing.length), 0, sweep_flag
      ).close_path
    end
  end
end
