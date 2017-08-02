module Plan
  # SVG Title element
  class SVGTitle < SVGElement
    def initialize(title)
      super('title')
      @data = title
    end
  end
end
