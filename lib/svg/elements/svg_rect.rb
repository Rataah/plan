module Plan
  # SVG rect element
  class SVGRect < SVGElement
    def initialize(x, y, width, height)
      super('rect')
      @args['x'] = SVGArg.new(x, true)
      @args['y'] = SVGArg.new(y, true)
      @args['width'] = SVGArg.new(width, true)
      @args['height'] = SVGArg.new(height, true)
    end
  end
end
