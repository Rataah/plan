module Plan
  class SVGText < SVGElement
    def initialize(text, x, y)
      super('text')
      @args['x'] = SVGArg.new(x, true, 'cm')
      @args['y'] = SVGArg.new(y, true, 'cm')
      @data = text
    end
  end
end