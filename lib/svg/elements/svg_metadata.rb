module Plan
  # SVG metadata element
  class SVGMetadata < SVGElement
    def initialize
      super('metadata')
      @elements = []
      @args['xmlns:dc'] = SVGArg.new('http://purl.org/dc/elements/1.1/', false)
    end

    def add(name, value)
      @elements << SVGMetadataElement.new(name, value) unless name.nil? || value.nil?
      self
    end

    def xml_element(xml_builder)
      super(xml_builder) do |xml_group|
        @elements.each { |element| element.xml_element(xml_group) }
      end
    end
  end

  class SVGMetadataElement < SVGElement
    def initialize(name, value)
      super("dc:#{name}")
      @data = value
    end
  end
end
