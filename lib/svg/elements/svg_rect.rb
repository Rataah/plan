module Plan
  # SVG rect element
  class SVGRect < SVGElement
    def initialize(x, y, width, height, rx = nil, ry = nil)
      super('rect')
      @args['x'] = SVGArg.new(x, true)
      @args['y'] = SVGArg.new(y, true)
      @args['width'] = SVGArg.new(width, true)
      @args['height'] = SVGArg.new(height, true)

      @args['rx'] = SVGArg.new(rx, true) if rx
      @args['ry'] = SVGArg.new(ry, true) if ry
    end
  end
end
