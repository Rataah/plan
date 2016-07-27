module Plan
  class Room

    def self.create(name, x, y, &block)
      Room.new.tap do |room|
        room.instance_eval do
          @name = name
          @point = Point.new(x, y)
          @walls = []

          if block
            instance_eval &block

            if @walls.first.A1 != @walls.last.A2
              Plan.log.debug("Room '#{name}': connect last wall to the first")
              @walls << Wall.connect("#{@name}_last", @walls.last, @walls.first, DEFAULT_WALL_WIDTH)
            end

            @vertices = @walls.map { |wall| [wall.A1, wall.A2] }.flatten.uniq

            min_x = @vertices.min_by(&:x).x
            max_x = @vertices.max_by(&:x).x
            min_y = @vertices.min_by(&:y).y
            max_y = @vertices.max_by(&:y).y

            @center = Point.new(min_x + (max_x - min_x)/2.0, min_y + (max_y - min_y)/2.0)
            @walls.each { |wall| wall.apply_width(@center) }
          end
        end
      end
    end

    def wall(wall_size, angle, name = nil)
      last_point = @walls.empty? ? @point : @walls.last.A2
      @walls << Wall.create(name, last_point, wall_size, angle, DEFAULT_WALL_WIDTH)

      @walls.last
    end

    def vertices
      @walls.map(&:vertices).flatten
    end

    def translate(x, y)
      @point.translate(x, y)
      @center.translate(x, y)
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
        floor.css_class 'floor'
        floor.css_class 'show_hover'
        elements << floor

        elements << @walls.map { |wall| wall.svg_element }
        elements << SVGText.new("#{@name}", @center.x, @center.y)
        elements << SVGText.new("#{area} m²", @center.x, @center.y + 20)
      end.flatten!
    end
  end
end