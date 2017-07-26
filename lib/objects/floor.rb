module Plan
  class Floor
    attr_accessor :wall_pool, :name, :rooms

    def initialize(name)
      @name = name
      @rooms = []
    end

    def id
      "floor_#{@name}"
    end

    def translate(x, y)
      @rooms.each { |room| room.translate(x, y) }
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
        end.css_class('floor')
      ]
    end
  end
end
