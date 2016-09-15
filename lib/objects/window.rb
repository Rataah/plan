module Plan
  class Window
    Wing = Struct.new(:origin, :length, :reverse)

    attr_accessor :origin, :length

    def initialize(origin, length)
      @origin = origin
      @length = length

      @wings = []
    end

    def wing(length, reverse = false, origin = nil)
      origin ||= @wings.any? ? @wings.last.origin : @origin
      @wings << Wing.new(origin, length, reverse)
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
        group.push(@wings.map{ |wing| wing_svg_element(wall, wing, window_a1) })
      end).css_class('window')
    end

    def wing_svg_element(wall, wing, window_a1)
      angle = wing.reverse ? -wall.angle : wall.angle
      wing_origin = window_a1.translate(angle, wing.origin)
      SVGPath.new(wing_origin).line_to(wing_origin.translate(angle, wing.length)).arc(
                   Point.new(wing.length, wing.length),
                   wing_origin.translate(-angle.rotate_rad, wing.length)
      ).close_path
    end
  end
end
