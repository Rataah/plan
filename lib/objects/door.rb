module Plan
  class Door
    Leave = Struct.new(:origin, :length, :angle, :reverse, :side)

    attr_accessor :origin, :length

    def initialize(origin, length)
      @origin = origin
      @length = length

      @leaves = []
    end

    def leave(length, reverse: false, origin: nil, angle: Math::PI / 2.0, outside: false)
      origin ||= @leaves.any? ? @leaves.last.origin + @leaves.last.length : 0
      @leaves << Leave.new(origin, length, angle, reverse, outside)
      self
    end

    def svg_elements(wall)
      Plan.log.debug("Draw SVG elements for Door of wall: #{wall.name}")
      window_a1 = wall.vertex_a1.translate(wall.angle, @origin)
      window_b1 = wall.vertex_b1.translate(wall.angle, @origin)
      window_a2 = window_a1.translate(wall.angle, @length)
      window_b2 = window_b1.translate(wall.angle, @length)

      window_center = wall.ab1.translate(wall.angle, @origin)
      SVGGroup.new("door_#{object_id}").add([].tap do |group|
        group.push(@leaves.map { |leave| leave_svg_element(wall.angle, leave, window_center) })
        group << SVGPolygon.new([window_a1, window_b1, window_b2, window_a2])
      end).css_class('door')
    end

    def leave_svg_element(angle, leave, window_anchor)
      leave_angle = angle.rotate_rad(leave.angle)
      line_angle = angle
      if leave.reverse
        line_angle += Math::PI
        leave_origin = window_anchor.translate(angle, leave.origin + leave.length)
        if leave.side
          leave_angle += Math::PI
          sweep_flag = 1
        else
          sweep_flag = 0
        end
      else
        leave_origin = window_anchor.translate(angle, leave.origin)
        if leave.side
          leave_angle += Math::PI
          sweep_flag = 0
        else
          sweep_flag = 1
        end
      end

      SVGPath.new(leave_origin).line_to(leave_origin.translate(line_angle, leave.length)).arc(
        Point.new(leave.length.abs, leave.length.abs),
        leave_origin.translate(leave_angle, leave.length), 0, sweep_flag
      ).close_path.fill('white')
    end
  end
end
