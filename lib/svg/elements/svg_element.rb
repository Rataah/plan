module Plan
  # Abstract svg element
  class SVGElement < SVGArgument
    def initialize(name, id = nil)
      super()
      id(id) if id
      @name = name
    end

    def xml_element(xml_builder, &block)
      svg_args = Hash[@args.map { |key, value| [key, SVGElement.prepare_value(value.value)] }]
      xml_builder.send(:comment, @xml_comments) if @xml_comments
      xml_builder.send("#{@name.downcase}_".to_sym, nil, svg_args, &block)
    end

    def self.prepare_value(value)
      case value
      when String
        value
      when Array then
        value.map { |item| prepare_value(item) }.join(' ')
      when Point then
        %(#{value.x.to_f},#{value.y.to_f})
      else
        value.to_f.to_s
      end
    end
  end
end
