module Plan
  # Represent a group of SVG element
  class SVGGroup < SVGElement
    def initialize(id)
      super('g', id.to_s.to_id)
      @elements = []

      yield self if block_given?
    end

    def add(*elements)
      @elements.concat(elements.flatten)
      self
    end

    def xml_element(xml_builder)
      super(xml_builder) do |xml_group|
        @elements.each { |element| element.xml_element(xml_group) }
      end
    end
  end
end
