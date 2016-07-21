module Plan
  class Wall
    attr_reader :vertex1, :vertex2, :name

    def initialize(v1, v2, name)
      @vertex1 = v1.dup
      @vertex2 = v2.dup
      @name = name
    end

    def width(width)
      @width = width
    end

    def vertices
      [@vertex1, @vertex2]
    end

    def distance
      @vertex1 - @vertex2
    end

    def translate(x, y)
      @vertex1.add(x, y)
      @vertex2.add(x, y)
    end

    def svg_element
      SVGLine.new(@vertex1.x, @vertex1.y, @vertex2.x, @vertex2.y).tap do |line|
        line.stroke_width(@width) if @width
        line.stroke
      end
    end
  end
end