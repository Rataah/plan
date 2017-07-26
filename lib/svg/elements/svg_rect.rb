module Plan
  # SVG rect element
  class SVGRect < SVGElement
    def initialize(x, y, width, height, rx = nil, ry = nil)
      super('rect')
      @args.merge!(
        x: SVGArg.new(x, true),
        y: SVGArg.new(y, true),
        width: SVGArg.new(width, true),
        height: SVGArg.new(height, true)
      )

      @args['rx'] = SVGArg.new(rx, true) if rx
      @args['ry'] = SVGArg.new(ry, true) if ry
    end
  end
end
