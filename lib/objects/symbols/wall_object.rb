module Plan
  class WallObject
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

    def finalize(angle, clockwise)
      translate(angle, self.class.amount || 10, clockwise)
    end

    def translate(angle, amount, clockwise)
      @coordinates = @coordinates.translate(angle, amount)
      @angle = @angle.rotate_rad(Math::PI) if clockwise
    end

    def svg_elements(symbol_pool)
      class_name = self.class.name.demodulize
      Plan.log.debug("Draw SVG elements for #{class_name}: #{@name}")
      respond_to?(:custom_svg_elements) ? custom_svg_elements(symbol_pool) : build_svg_elements(symbol_pool)
    end

    def build_svg_elements(_)
      SVGUse.new(*@coordinates.xy, self.class.wall_object).tap do |svg_use|
        svg_use.css_class('symbol')
        svg_use.rotate(@angle.rotate_rad.deg, *@coordinates.xy) if @rotation
      end
    end

    class << self
      attr_reader :wall_object, :amount

      def object(wall_object)
        @wall_object = wall_object
      end

      def amount_translation(amount)
        @amount = amount
      end

      def rotate(rotation)
        @rotation = rotation
      end
    end
  end
end
