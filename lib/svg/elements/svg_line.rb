module Plan
  # SVG line element
  class SVGLine < SVGElement
    def initialize(point1, point2)
      super('line')
      @args['x1'] = SVGArg.new(point1.x, true)
      @args['y1'] = SVGArg.new(point1.y, true)
      @args['x2'] = SVGArg.new(point2.x, true)
      @args['y2'] = SVGArg.new(point2.y, true)
    end
  end
end
