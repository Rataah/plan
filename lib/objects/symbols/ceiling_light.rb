module Plan
  class CeilingLight
    SYMBOL = 'symbol-ceiling-light'.freeze

    attr_accessor :name, :coordinates

    def initialize(name, coordinates)
      @name = name
      @coordinates = coordinates
      @links = []
    end

    def link(symbol_name)
      @links << symbol_name
      self
    end

    def svg_elements(symbol_pool)
      Plan.log.debug("Draw SVG elements for Ceiling Light: #{@name}")
      [SVGUse.new(*@coordinates.xy, SYMBOL).css_class('symbol').css_class('ceiling-light')].tap do |elements|
        @links.each do |link|
          symbol = symbol_pool[link]
          elements << SVGPath.curve(@coordinates, symbol.coordinates).fill('transparent').stroke('red')
        end
      end
    end
  end
end
