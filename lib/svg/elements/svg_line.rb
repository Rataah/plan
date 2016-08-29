module Plan
  # SVG line element
  class SVGLine < SVGElement
    def initialize(start_point, end_point)
      super('line')
      @args['x1'] = SVGArg.new(start_point.x, true)
      @args['y1'] = SVGArg.new(start_point.y, true)
      @args['x2'] = SVGArg.new(end_point.x, true)
      @args['y2'] = SVGArg.new(end_point.y, true)
    end
  end
end
