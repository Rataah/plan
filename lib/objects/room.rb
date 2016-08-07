module Plan
  class Room
    attr_accessor :name, :center, :walls, :origin

    def vertices
      @walls.map(&:vertices).flatten
    end

    def translate(x, y)
      @origin.translate(x, y)
      @center.translate(x, y)
      @walls.each { |wall| wall.translate(x, y) }
    end

    def area
      sum = 0.0
      @walls.map { |wall| wall.room_vertices(self) }.flatten.each_cons(2) do |v1, v2|
        sum += (v1.x * v2.y) - (v1.y * v2.x)
      end
      (sum / 2.0).abs / 10000.0
    end


    def svg_elements
      [].tap do |elements|
        floor = SVGPolygon.new(@walls.select{ |wall| wall.primary?(self) }.map(&:vertices).flatten.uniq).fill('white')
        floor.css_class 'show_hover'
        elements << floor

        elements << @walls.map { |wall| wall.svg_element }
        elements << SVGText.new("#{@name}", @center.x, @center.y)
        elements << SVGText.new("#{area} m²", @center.x, @center.y + 20)
      end.flatten!
    end
  end
end