module Plan
  ANGLE_SHORTCUTS = {
      up: 270.0,
      down: 90.0,
      left: 180.0,
      right: 0.0
  }

  DEFAULT_WALL_WIDTH = 2.freeze

  class Wall
    attr_accessor :vertex_a1, :vertex_a2, :vertex_b1, :vertex_b2, :name, :angle, :length, :width
    alias_method :A1, :vertex_a1
    alias_method :A2, :vertex_a2
    alias_method :B1, :vertex_b1
    alias_method :B2, :vertex_b2

    def self.create(name, origin, length, angle, width)
      Wall.new.tap do |wall|
        wall.instance_eval do
          @name = name

          # retrieve the angle
          @angle = (angle.is_a?(Symbol) ? ANGLE_SHORTCUTS[angle] : angle).rad
          @length = length
          @width = width

          # compute the points
          @vertex_a1 = origin.dup.round(2)
          @vertex_a2 = @vertex_a1.add(length * Math.cos(@angle), length * Math.sin(@angle)).round(2)
        end
      end
    end

    def self.connect(name, wall1, wall2, width)
      Wall.new.tap do |wall|
        wall.instance_eval do
          @name = name
          @width = width

          @vertex_a1 = wall1.A2.dup.round(2)
          @vertex_a2 = wall2.A1.dup.round(2)

          @length = @vertex_a1.dist @vertex_a2
          @angle = Math.atan2(*(@vertex_a1 - @vertex_a2).xy).deg.round(2) - 90.0
          Plan.log.debug("Wall '#{name}' connect angle: #{@angle}")
        end
      end
    end

    def apply_width(ref_point)
      direction = -90.0 * (((@vertex_a2.x - @vertex_a1.x) * (ref_point.y - @vertex_a1.y) - (@vertex_a2.y - @vertex_a1.y) * (ref_point.x - @vertex_a1.x)) <=> 0.0)
      @vertex_b1 = @vertex_a1.add(@width * Math.cos(@angle + direction.rad), @width * Math.sin(@angle + direction.rad)).round(2)
      @vertex_b2 = @vertex_a2.add(@width * Math.cos(@angle + direction.rad), @width * Math.sin(@angle + direction.rad)).round(2)
    end

    def vertices
      [@vertex_a1, @vertex_a2, @vertex_b2, @vertex_b1]
    end

    def distance
      @vertex_a1.dist @vertex_a2
    end

    def translate(x, y)
      vertices.each { |vertex| vertex.translate(x, y) }
    end

    def svg_element
      SVGPolygon.new(vertices).stroke('black').fill('gray')
    end
  end
end