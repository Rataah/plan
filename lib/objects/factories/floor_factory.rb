module Plan
  # Room factory. Create a room and manage his walls (with WallSegment)
  class FloorFactory
    attr_reader :room

    def create(name, &block)
      @floor = Floor.new(name)
      @floor.wall_pool = WallPool[@floor]
      @floor.symbol_pool = SymbolPool[@floor]

      @room_factory = RoomFactory.new(@floor.wall_pool, @floor.symbol_pool)
      instance_exec(@floor, &block)

      @floor.rooms = @room_factory.rooms
      @floor
    end

    def room(name, coord_x = 0, coord_y = 0, anchor: nil, &block)
      coordinates = Point.new(coord_x, coord_y)
      coordinates = DataLoader.retrieve_anchor(@floor.wall_pool, anchor) if anchor
      @room_factory.create(name, coordinates, &block)
    end
  end
end
