module Plan
  class Room
    attr_accessor :name, :center, :walls, :origin

    def vertices
      WallPool.walls(self).map(&:vertices).flatten
    end

    def translate(x, y)
      @origin.translate(x, y)
      @center.translate(x, y)
    end

    def area
      sum = 0.0
      vertices.each_cons(2) do |v1, v2|
        sum += ((v1.x * v2.y) - (v1.y * v2.x))
      end
      (sum / 2.0).abs / 10000.0
    end

    def svg_elements
      Plan.log.debug("Draw SVG elements for Room: #{@name}")
      [].tap do |elements|
        floor = SVGPolygon.new(vertices.uniq).stroke('red')
        floor.css_class 'show_hover'
        elements << floor

        elements << SVGText.new("#{@name}", @center.x, @center.y)
        elements << SVGText.new("#{area} m²", @center.x, @center.y + 20)
      end.flatten
    end
  end
end