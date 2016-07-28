module Plan
  class Room

    def self.create(name, x = nil, y = nil, anchor: nil, &block)
      Room.new.tap do |room|
        room.instance_eval do
          @name = name
          @point = (anchor || Point.new(x, y)).dup
          @walls = []

          if block
            instance_eval &block

            if @walls.first.AB1(self) != @walls.last.AB2(self)
              Plan.log.debug("Room '#{name}': connect last wall to the first")
              @walls << Wall.connect(self, "#{@name}_last", @walls.last, @walls.first, DEFAULT_WALL_WIDTH)
            end

            @vertices = @walls.map { |wall| wall.room_vertices(self) }.flatten.uniq

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

    def wall(wall_size, angle, width: DEFAULT_WALL_WIDTH, name: nil)
      last_point = @walls.empty? ? @point : @walls.last.AB2(self)
      @walls << Wall.create(self, name, last_point, wall_size, angle, width)

      @walls.last
    end

    def use_wall(name, wall_size, angle)
      last_point = @walls.empty? ? @point : @walls.last.AB2(self)
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