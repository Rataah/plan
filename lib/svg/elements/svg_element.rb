module Plan
  SVGArg = Struct.new(:value, :scalable)

  class SVGElement
    def initialize(name)
      @name = name
      @args = {}
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

    def xml_element(xml_builder)
      puts "generating #{@name}"
      svg_args = Hash[@args.map { |key, value| [key, SVGElement.prepare_value(value.value)] }]
      xml_builder.send("#{@name.downcase}_".to_sym, @data, svg_args)
    end

    def self.prepare_value(value)
      case value
        when String
          value
        when Array then
          value.map { |v| prepare_value(v) }.join(' ')
        when Point then
          %Q(#{value.x.to_f},#{value.y.to_f})
        else
          "#{value.to_f}"
      end
    end
  end
end