module Plan
  class RoomObject
    attr_accessor :name, :coordinates

    def initialize(name, coordinates)
      @name = name
      @coordinates = coordinates
    end

    def self.create_from_room(name, coordinate_x, coordinate_y, room)
      new(name, room.min_bound.add(coordinate_x, coordinate_y))
    end

    def svg_elements(_)
      class_name = self.class.name.demodulize
      Plan.log.debug("Draw SVG elements for #{class_name}: #{@name}")
      SVGUse.new(*@coordinates.xy, self.class.room_object)
            .css_class('symbol')
            .css_class(class_name.downcase)
    end

    class << self
      attr_reader :room_object

      def object(room_object)
        @room_object = room_object
      end
    end
  end
end
