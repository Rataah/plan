module Plan
  class Room
    attr_accessor :name, :center, :walls, :origin

    def vertices
      @walls.map{ |wall| wall.room_vertices(self) }.flatten.uniq.sort_by do |point|
        Math.atan2(*(point - @center).xy)
      end
    end

    def translate(x, y)
      @origin.translate(x, y)
      @center.translate(x, y)
      primary_walls.each { |wall| wall.translate(x, y) }
    end

    def area
      sum = 0.0
      vertices.each_cons(2) do |v1, v2|
        sum += (v1.x * v2.y) - (v1.y * v2.x)
      end
      (sum / 2.0).abs / 10000.0
    end

    def primary_walls
      @walls.select { |wall| wall.primary? self }
    end

    def svg_elements
      [].tap do |elements|
        floor = SVGPolygon.new(vertices).css_class('floor')
        floor.css_class 'show_hover'
        elements << floor

        elements << primary_walls.map { |wall| wall.svg_element }
        elements << SVGText.new("#{@name}", @center.x, @center.y)
        elements << SVGText.new("#{area} m²", @center.x, @center.y + 20)

        vertices.each do |point|
          elements << SVGLine.new(point.x, point.y, @center.x, @center.y).stroke('red')
        end

      end.flatten!
    end
  end
end