module Plan
  SVGArg = Struct.new(:value, :scalable)

  class SVGArgument
    attr_accessor :args

    def initialize
      @args = {}
    end

    def merge(svg_arguments)
      @args.merge!(svg_arguments.args)
      self
    end

    def css_class(name)
      @args['class'] ||= SVGArg.new('', false)
      @args['class'].value << "#{name} "
      self
    end

    def stroke_width(value)
      @args['stroke-width'] = SVGArg.new(value, true)
      self
    end

    def stroke(value = 'black')
      @args['stroke'] = SVGArg.new(value, false)
      self
    end

    def fill(value)
      @args['fill'] = SVGArg.new(value, false)
      self
    end
  end
end