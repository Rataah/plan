module Plan
  class RoomObject
    attr_accessor :name, :coordinates

    def initialize(name, coordinates, rotation)
      @name = name
      @coordinates = coordinates
      @rotation = rotation
    end

    def self.create_from_room(room, name, coordinate_x, coordinate_y, rotation = nil)
      new(name, room.min_bound.add(coordinate_x, coordinate_y), rotation)
    end

    def svg_elements(_)
      class_name = self.class.name.demodulize
      Plan.log.debug("Draw SVG elements for #{class_name}: #{@name}")
      SVGUse.new(*@coordinates.xy, self.class.room_object).tap do |svg_object|
        svg_object.css_class('symbol')
        svg_object.css_class(class_name.downcase)
        svg_object.css_class(self.class.css_class) if self.class.css_class
        svg_object.rotate(@rotation, *@coordinates.xy) if @rotation
      end
    end

    class << self
      attr_reader :room_object, :css_class

      def object(room_object)
        @room_object = room_object
      end

      def css(css_class)
        @css_class = css_class
      end
    end
  end
end
