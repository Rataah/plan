module Plan
  # SVG line element
  class SVGLine < SVGElement
    def initialize(start_point, end_point)
      super('line')
      @args.merge!(
        x1: SVGArg.new(start_point.x, true),
        y1: SVGArg.new(start_point.y, true),
        x2: SVGArg.new(end_point.x, true),
        y2: SVGArg.new(end_point.y, true)
      )
    end
  end
end
