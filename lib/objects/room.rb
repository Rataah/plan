module Plan
  # Represent a room. A room has a name, an origin and a center
  class Room
    attr_accessor :name, :center, :origin

    def initialize(wall_pool, name, origin)
      @wall_pool = wall_pool
      @name = name
      @origin = origin
    end

    def vertices
      @wall_pool.walls(self).map(&:vertices).flatten.uniq
    end

    def translate(x, y)
      @origin.add!(x, y)
      @center.add!(x, y)
    end

    def area
      sum = 0.0
      area_vertices = vertices
      (area_vertices + [area_vertices.first]).each_cons(2) do |v1, v2|
        sum += ((v1.x * v2.y) - (v1.y * v2.x))
      end
      (sum / 2.0).abs / 10_000.0
    end

    def svg_elements
      Plan.log.debug("Draw SVG elements for Room: #{@name}")
      [
        SVGPolygon.new(vertices).css_class('room-stroke'),
        SVGGroup.new("room_#{@name}").add([].tap do |elements|
          elements << SVGPolygon.new(vertices).css_class('room-floor')
          elements << SVGText.new(@name.to_s, @center).css_class('room-name').anchor(:middle)
          elements << SVGText.new("#{area.round(2)} m²", @center.add(0, 20)).anchor(:middle)
          @wall_pool.walls(self).each { |wall_segment| elements.push(wall_segment.svg_elements) }
        end.flatten).comments(@name).css_class('show_hover')
      ]
    end
  end
end
