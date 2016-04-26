module Plan
  SVGArg = Struct.new(:value, :scalable, :cm)
  class SVGElement
    def initialize(name)
      @name = name
      @args = {}
    end

    def stroke_width(value)
      @args['stroke-width'] = SVGArg.new(value, true, 'cm')
    end

    def stroke(value = 'black')
      @args['stroke'] = SVGArg.new(value, false)
    end

    def fill(value)
      @args['fill'] = SVGArg.new(value, false)
    end

    def show_on_mouse_over
      @args['visibility'] = SVGArg.new('hidden', false)
      @args['onmouseover'] = SVGArg.new("evt.target.setAttribute('visibility', 'visible');", false)
      @args['onmouseout'] = SVGArg.new("evt.target.setAttribute('visibility', 'hidden');", false)
    end

    def xml_element(scale)
      ''.tap do |element|
        element << %Q(<#{@name.downcase} )
        @args.each do |key, svg_arg|
          svg_arg.value = SVGElement.scale_value(svg_arg.value, scale, svg_arg.cm) if svg_arg.scalable
          element << %Q(#{key}="#{svg_arg.value}" )
        end
        element << %Q(>)

        element << (@data.is_a?(SVGElement) ? @data.xml_element(scale) : (@data || ''))
        element << %Q(</#{@name.downcase}>)
      end
    end

    def self.scale_value(value, scale, cm)
      case value
        when Array then
          value.map { |v| scale_value(v, scale, cm) }.join(' ')
        when Point then
          %Q(#{value.x.to_f / scale},#{value.y.to_f / scale})
        else
          "#{value.to_f / scale}"
      end
    end
  end
end