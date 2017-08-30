module Plan
  class WallSymbol
    attr_accessor :name, :coordinates

    def initialize(name, coordinates, angle, type)
      @name = name
      @coordinates = coordinates
      @angle = angle
      @type = type
    end

    def self.create_from_wall(name, origin, wall, type)
      coordinates = wall.vertex_a1.translate(wall.angle, origin)
      new(name, coordinates, wall.angle, type)
    end

    def translate(angle, amount, clockwise)
      @coordinates = @coordinates.translate(angle, amount)
      @angle = @angle.rotate_rad(Math::PI) if clockwise
    end

    def svg_elements(_)
      class_name = self.class.name.demodulize
      Plan.log.debug("Draw SVG elements for #{class_name}: #{@name}")
      element = SVGUse.new(*@coordinates.xy, symbol)
            .css_class('symbol')
            .css_class(class_name.downcase)
      element.rotate(@angle.rotate_rad.deg, *@coordinates.xy) if rotate?
      element
    end

    private

    def symbol
      raise NotImplementedError
    end

    def rotate?
      true
    end
  end
end
