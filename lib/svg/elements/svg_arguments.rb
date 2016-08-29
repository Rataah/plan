module Plan
  SVGArg = Struct.new(:value, :scalable)

  # Manage SVG element's arguments
  class SVGArgument
    attr_accessor :args, :xml_comments

    def initialize
      @args = {}
    end

    def merge!(svg_arguments)
      @args.merge!(svg_arguments.args)
      self
    end

    def id(value)
      @args['id'] = SVGArg.new(value, false)
      self
    end

    def css_class(name)
      @args['class'] ||= SVGArg.new('', false)
      @args['class'].value << ' ' unless @args['class'].value.empty?
      @args['class'].value << name
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

    def opacity(value)
      @args['opacity'] = SVGArg.new(value, false)
      self
    end

    def comments(comment)
      @xml_comments = comment
      self
    end
  end
end
