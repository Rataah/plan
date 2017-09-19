module Plan
  # Metadata factory
  class MetadataFactory
    attr_reader :metadata

    def self.create(&block)
      MetadataFactory.new.instance_eval do
        @metadata = Metadata.new
        instance_exec(@metadata, &block)
        @metadata
      end
    end

    def author(author)
      @metadata.authors << author
    end

    def title(title)
      @metadata.title = title
    end

    def version(version)
      @metadata.version = version
    end

    def compass(angle, coordinate_x, coordinate_y)
      @metadata.compass = Compass.new(angle, Point.new(coordinate_x, coordinate_y))
    end
  end
end
