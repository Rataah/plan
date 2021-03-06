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

    def area
      sum = 0.0
      vertices.loop_array.each_cons(2) do |v1, v2|
        sum += ((v1.x * v2.y) - (v1.y * v2.x))
      end
      (sum / 2.0).abs / 10_000.0
    end

    def clockwise?
      sum = 0.0
      vertices.loop_array.each_cons(2) do |v1, v2|
        sum += (v2.x - v1.x) * (v2.y + v1.y)
      end
      sum.positive?
    end

    def min_bound
      Plan.bounds(vertices).first
    end

    def svg_elements
      Plan.log.debug("Draw SVG elements for Room: #{@name}")
      [
        SVGPolygon.new(vertices).css_class('room-stroke'),
        svg_elements_group.comments(@name).css_class('show_hover')
      ]
    end

    private

    def svg_elements_group
      SVGGroup.new("room_#{@name}").add([].tap do |elements|
        elements << SVGPolygon.new(vertices).css_class('room-floor')
        elements << SVGText.new(@name.to_s, @center).css_class('room-name').anchor(:middle)
        elements << SVGText.new("#{area.round(2)} m²", @center.add(0, 20)).anchor(:middle)
        @wall_pool.walls(self).each { |wall_segment| elements.push(wall_segment.svg_elements) }
      end.flatten)
    end
  end
end
