module Plan
  class SVGLine < SVGElement
    def initialize(x1, y1, x2, y2)
      super('line')
      @args['x1'] = SVGArg.new(x1, true, 'cm')
      @args['y1'] = SVGArg.new(y1, true, 'cm')
      @args['x2'] = SVGArg.new(x2, true, 'cm')
      @args['y2'] = SVGArg.new(y2, true, 'cm')
    end
  end
end