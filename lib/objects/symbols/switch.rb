module Plan
  class Switch
    SYMBOL = 'symbol-switch-simple'.freeze

    attr_accessor :name, :coordinates

    def initialize(name, coordinates, angle)
      @name = name
      @coordinates = coordinates
      @angle = angle
    end

    def self.create_from_wall(name, origin, wall)
      coordinates = wall.vertex_a1.translate(wall.angle, origin)
      Switch.new(name, coordinates, wall.angle)
    end

    def translate(angle, amount)
      @coordinates = @coordinates.translate(angle, amount)
    end

    def svg_elements
      Plan.log.debug("Draw SVG elements for Switch: #{@name}")
      SVGUse.new(*@coordinates.xy, SYMBOL).css_class('symbol').css_class('switch')
    end
  end
end
