module Plan
  ANGLE_SHORTCUTS = {
      up: 270.0,
      down: 90.0,
      left: 180.0,
      right: 0.0
  }

  DEFAULT_WALL_WIDTH = 2.freeze

  class Wall < SVGArgument
    attr_accessor :vertex_a1, :vertex_a2, :vertex_b1, :vertex_b2, :name, :angle, :length, :width,
                  :room_a, :room_b
    alias_method :A1, :vertex_a1
    alias_method :A2, :vertex_a2
    alias_method :B1, :vertex_b1
    alias_method :B2, :vertex_b2

    def AB1(room)
      primary?(room) ? @vertex_a1 : @vertex_b1
    end

    def AB2(room)
      primary?(room) ? @vertex_a2 : @vertex_b2
    end

    def initialized?
      @vertex_b1 && @vertex_b2
    end

    def primary?(room)
      @room_a == room
    end

    def belongs_to?(room)
      @room_a == room || @room_b == room
    end

    def apply_width(ref_point)
      return if initialized?
      direction = -90.0 * (((@vertex_a2.x - @vertex_a1.x) * (ref_point.y - @vertex_a1.y) - (@vertex_a2.y - @vertex_a1.y) * (ref_point.x - @vertex_a1.x)) <=> 0.0)
      @vertex_b1 = @vertex_a1.add(@width * Math.cos(@angle + direction.rad), @width * Math.sin(@angle + direction.rad)).round(2)
      @vertex_b2 = @vertex_a2.add(@width * Math.cos(@angle + direction.rad), @width * Math.sin(@angle + direction.rad)).round(2)
    end

    def room_vertices(room)
      case room
        when @room_a then [@vertex_a1, @vertex_a2]
        when @room_b then [@vertex_b1, @vertex_b2]
        else raise StandardError.new "Unknown room #{room.name} (#{@room_a.name}, #{@room_b.name})"
      end
    end

    def vertices
      [@vertex_a1, @vertex_a2, @vertex_b2, @vertex_b1]
    end

    def distance(room)
      case room
        when @room_a then @vertex_a1.dist @vertex_a2
        when @room_b then @vertex_b1.dist @vertex_b2
        else raise StandardError.new 'Unknown room'
      end
    end

    def translate(x, y)
      vertices.each { |vertex| vertex.translate(x, y) }
    end

    def svg_element
      SVGPolygon.new(vertices).stroke('black').css_class('highlight').comments(@name).merge!(self)
    end
  end
end