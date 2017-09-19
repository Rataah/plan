module Plan
  class Compass
    SVG_ID = 'symbol-compass'.freeze

    def initialize(angle, coordinates)
      @angle = angle
      @coordinates = coordinates
    end

    def svg_elements
      Plan.log.debug("Draw Compass: North at #{@angle} degree")
      SVGUse.new(*@coordinates.xy, Compass::SVG_ID).tap do |svg_use|
        svg_use.css_class('compass')
        svg_use.rotate(@angle, *@coordinates.add(16, 16).xy)
      end
    end
  end
end
