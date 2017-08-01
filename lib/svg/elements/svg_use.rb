module Plan
  # SVG use element
  class SVGUse < SVGElement
    def initialize(x, y, href)
      super('use')
      namespace('xlink', 'http://www.w3.org/1999/xlink')
      @args[:x] = SVGArg.new(x, true)
      @args[:y] = SVGArg.new(y, true)
      @args['xlink:href'] = SVGArg.new("##{href}", false)
    end
  end
end
