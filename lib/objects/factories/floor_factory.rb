module Plan
  # Room factory. Create a room and manage his walls (with WallSegment)
  class FloorFactory
    attr_reader :room

    def self.create(name, &block)
      FloorFactory.new.instance_eval do
        @floor = Floor.new(name)
        @floor.wall_pool = WallPool[@floor]

        @rooms = []
        instance_exec(@floor, &block)

        @floor.rooms.concat(@rooms)
        @floor
      end
    end

    def room(*args, &block)
      if args.last.is_a?(Hash) && args.last.key?(:anchor)
        args.last[:anchor] = DataLoader.retrieve_anchor(@floor.wall_pool, args.last[:anchor])
      end

      @rooms << RoomFactory.create(WallPool[@floor], *args, &block)
    end
  end
end
