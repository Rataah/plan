module Plan
  class SVGPolygon < SVGElement
    def initialize(points)
      super('polygon')
      @args['points'] = SVGArg.new(points, true)
    end
  end
end