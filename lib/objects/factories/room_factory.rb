module Plan
  # Room factory. Create a room and manage his walls (with WallSegment)
  class RoomFactory
    attr_reader :rooms

    def initialize(wall_pool, symbol_pool)
      @wall_pool = wall_pool
      @symbol_pool = symbol_pool
      @rooms = []

      @plugins = PluginLoader.room_plugin_methods
    end

    def create(name, coordinates, &block)
      @room = Room.new(@wall_pool, name, coordinates.dup)
      @last_point = @room.origin

      @wall_factory = WallFactory.new(@wall_pool, @symbol_pool)
      instance_exec(@room, &block)

      @room.center = Plan.center(@room.vertices)
      @wall_factory.post_process(@room)

      @rooms << @room
    end

    def respond_to_missing?(method_name)
      @plugins.key? method_name
    end

    def method_missing(method_name, *args)
      if @plugins.key? method_name
        @symbol_pool.store @plugins[method_name].create_from_room(@room, *args)
      else
        super
      end
    end

    def wall(wall_size, angle, width: DEFAULT_WALL_WIDTH, name: nil, &block)
      wall = @wall_factory.create(
        name ? name : "#{@room.name}_#{@wall_pool.walls(@room).size}",
        @last_point,
        wall_size,
        angle,
        width,
        &block
      )
      @last_point = wall.a2
      @wall_pool.add_link(@room, wall, SegmentIndex.new(:a, 0), SegmentIndex.new(:a, 1), wall.angle)
    end
  end
end
