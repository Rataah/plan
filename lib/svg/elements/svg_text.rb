module Plan
  # SVG Text element
  class SVGText < SVGElement
    def initialize(text, point)
      super('text')
      @args['x'] = SVGArg.new(point.x, true)
      @args['y'] = SVGArg.new(point.y, true)
      @data = text
    end

    def anchor(value)
      @args['text-anchor'] = SVGArg.new(value.to_s, false)
      self
    end
  end
end
