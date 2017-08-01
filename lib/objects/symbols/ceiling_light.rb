module Plan
  class CeilingLight
    SYMBOL_LIGHT = 'symbol-ceiling-light'.freeze

    attr_accessor :coord_x, :coord_y

    def initialize(name, coordinates)
      @name = name
      @coordinates = coordinates
    end
  end
end
