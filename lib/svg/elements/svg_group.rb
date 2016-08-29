module Plan
  class SVGGroup < SVGElement
    def initialize(id)
      super('g', id)
      @elements = []
    end

    def add(elements)
      @elements.push(*elements)
      self
    end

    def xml_element(xml_builder)
      super(xml_builder) do |xml_group|
        @elements.each { |element| element.xml_element(xml_group) }
      end
    end
  end
end