module Plan
  # Represent a room. A room has a name, an origin and a center
  class Room
    attr_accessor :name, :center, :origin

    def initialize(name, origin)
      @name = name
      @origin = origin
    end

    def vertices
      WallPool.walls(self).map(&:vertices).flatten
    end

    def translate(x, y)
      @origin.add!(x, y)
      @center.add!(x, y)
    end

    def area
      sum = 0.0
      vertices.each_cons(2) do |v1, v2|
        sum += ((v1.x * v2.y) - (v1.y * v2.x))
      end
      (sum / 2.0).abs / 10_000.0
    end

    def svg_elements
      Plan.log.debug("Draw SVG elements for Room: #{@name}")
      SVGGroup.new(@name.to_id) do |group|
        group.add SVGPolygon.new(vertices.uniq).fill('beige').stroke('red')
        group.add SVGText.new(@name.to_s, @center).css_class('room-name').anchor(:middle)
        group.add SVGText.new("#{area} m²", @center.add(0, 20)).anchor(:middle)

        group.add WallPool.walls(self).map { |wall_segment| wall_segment.svg_elements(@center) }
      end.comments(@name).css_class 'show_hover'
    end
  end
end
