module Plan
  # SVG Text element
  class SVGText < SVGElement
    def initialize(text, point)
      super('text')
      @args['x'] = SVGArg.new(point.x, true)
      @args['y'] = SVGArg.new(point.y, true)
      @data = text
    end

    def rotate(angle)
      @args['transform'] = SVGArg.new("rotate(#{(angle.deg+90.0) % 180.0} #{@args['x'].value}, #{@args['y'].value})", false)
      self
    end
  end
end
