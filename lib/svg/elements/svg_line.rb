module Plan
  class SVGLine < SVGElement
    def initialize(x1, y1, x2, y2)
      super('line')
      @args['x1'] = SVGArg.new(x1, true)
      @args['y1'] = SVGArg.new(y1, true)
      @args['x2'] = SVGArg.new(x2, true)
      @args['y2'] = SVGArg.new(y2, true)
    end
  end
end