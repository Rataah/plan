module Plan
  class Metadata
    attr_accessor :title, :version, :authors, :compass

    def initialize
      @authors = []
    end

    def svg_metadata_elements
      [
        SVGTitle.new("#{title} (#{version})"),
        SVGMetadata.new
                   .add('title', title)
                   .add('identifier', version)
                   .add('creator', authors.join(', '))
      ]
    end

    def svg_elements
      [@compass.svg_elements]
    end
  end
end
