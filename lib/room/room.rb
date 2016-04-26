module Plan
  class Room

    def create(name, x, y, &block)
      @name = name
      @point = Point.new(x, y)
      @walls = []

      if block
        instance_eval &block

        @walls << Wall.new(@walls.last.vertex2, @point, nil)
        @vertices = @walls.map { |wall| [wall.vertex1, wall.vertex2] }.flatten.uniq

        min_x = @vertices.min_by(&:x).x
        max_x = @vertices.max_by(&:x).x
        min_y = @vertices.min_by(&:y).y
        max_y = @vertices.max_by(&:y).y

        @center = Point.new(min_x + (max_x - min_x)/2.0, min_y + (max_y - min_y)/2.0)
      end
      self
    end

    def wall(wall_size, direction, name = nil)
      last_point = @walls.empty? ? @point : @walls.last.vertex2

      case direction
        when :down
          @walls << Wall.new(last_point, Point.new(last_point.x, last_point.y + wall_size), name)
        when :up
          @walls << Wall.new(last_point, Point.new(last_point.x, last_point.y - wall_size), name)
        when :left
          @walls << Wall.new(last_point, Point.new(last_point.x - wall_size, last_point.y), name)
        when :right
          @walls << Wall.new(last_point, Point.new(last_point.x + wall_size, last_point.y), name)
        else
          raise 'Direction unknown'
      end

      @walls.last
    end

    def floor
      @floor = true
    end

    def vertices
      @walls.map(&:vertices).flatten
    end

    def translate(x, y)
      @point.add(x, y)
      @center.add(x, y)
      @walls.each { |wall| wall.translate(x, y) }
    end

    def area
      sum = 0.0
      @vertices.each_index do |index|
        v1 = @vertices[index - 1]
        v2 = @vertices[index]

        sum += (v1.x * v2.y) - (v1.y * v2.x)
      end
      (sum / 2.0).abs / 10000.0
    end


    def svg_elements
      [].tap do |elements|
        floor = SVGPolygon.new(@walls.map(&:vertices).flatten.uniq)
        floor.fill('red')
        floor.show_on_mouse_over
        elements << floor

        elements << @walls.map { |wall| wall.svg_element }
        elements << SVGText.new("#{@name}", @center.x, @center.y)
        elements << SVGText.new("#{area} m²", @center.x, @center.y + 20)
      end.flatten!
    end
  end
end