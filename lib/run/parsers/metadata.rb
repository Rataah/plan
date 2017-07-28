module Plan
  class Metadata
    attr_accessor :title, :version, :authors

    def initialize
      @authors = []
    end

    def svg_elements
      [
        SVGTitle.new("#{title} (#{version})"),
        SVGMetadata.new
                   .add('title', title)
                   .add('identifier', version)
                   .add('creator', authors.join(', '))
      ]
    end
  end
end
