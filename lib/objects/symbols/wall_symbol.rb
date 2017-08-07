module Plan
  class WallSymbol
    attr_accessor :name, :coordinates

    def initialize(name, coordinates, angle)
      @name = name
      @coordinates = coordinates
      @angle = angle
    end

    def self.create_from_wall(name, origin, wall)
      coordinates = wall.vertex_a1.translate(wall.angle, origin)
      new(name, coordinates, wall.angle)
    end

    def translate(angle, amount, clockwise)
      @coordinates = @coordinates.translate(angle, amount)
      @angle = @angle.rotate_rad(Math::PI) if clockwise
    end

    def svg_elements(_)
      class_name = self.class.name.demodulize
      Plan.log.debug("Draw SVG elements for #{class_name}: #{@name}")
      SVGUse.new(*@coordinates.xy, symbol)
            .rotate(@angle.rotate_rad.deg, *@coordinates.xy)
            .css_class('symbol')
            .css_class(class_name.downcase)
    end

    private

    def symbol
      raise NotImplementedError
    end
  end
end
