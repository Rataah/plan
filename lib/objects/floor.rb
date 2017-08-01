module Plan
  class Floor
    attr_accessor :wall_pool, :symbol_pool, :name, :rooms, :symbols

    def initialize(name)
      @name = name
      @rooms = []
    end

    def id
      "floor_#{@name}"
    end

    def vertices
      @wall_pool.all.map(&:vertices).flatten
    end

    def area
      @rooms.map(&:area).reduce(0, :+)
    end

    def svg_elements
      Plan.log.debug("Draw SVG elements for Floor: #{@name}")
      [
        SVGGroup.new(id).add do |elements|
          elements.concat(@rooms.map(&:svg_elements))
          elements.concat(@wall_pool.all.map(&:svg_elements))
          elements.concat(@symbol_pool.all.map(&:svg_elements))
        end.css_class('floor')
      ]
    end
  end
end
