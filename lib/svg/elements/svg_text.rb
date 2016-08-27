module Plan
  # SVG Text element
  class SVGText < SVGElement
    def initialize(text, x, y)
      super('text')
      @args['x'] = SVGArg.new(x, true)
      @args['y'] = SVGArg.new(y, true)
      @data = text
    end
  end
end
