module Plan
  # Wall factory. Create a wall
  class WallFactory
    attr_reader :symbols

    def initialize(wall_pool, symbol_pool)
      @wall_pool = wall_pool
      @symbol_pool = symbol_pool
      @walls = []
      @symbols = {}

      @plugins = PluginLoader.wall_plugin_methods
    end

    def create(name, origin, length, angle, width, &block)
      @wall = @wall_pool.create_and_store do |wall|
        wall.name = name
        wall.width = width

        # retrieve the angle
        wall.angle = (angle.is_a?(Symbol) ? ANGLE_SHORTCUTS[angle] : angle).rad
        wall.length = length

        # compute the points
        wall.vertices_a = [origin.dup, origin.translate(wall.angle, wall.length)]
      end
      @symbols[@wall.name] = []

      instance_eval(&block) if block_given?
      (@walls << @wall).last
    end

    def respond_to_missing?(method_name)
      @plugins.key? method_name
    end

    def method_missing(method_name, *args)
      if @plugins.key? method_name
        (@symbols[@wall.name] << @plugins[method_name].create_from_wall(*args, @wall)).last
      else
        super
      end
    end

    def post_process(room)
      @walls.each do |wall|
        (wall.windows + wall.doors).each { |opening| opening.add_center(room.center) }

        direction = wall.angle + Plan.normal_angle(room.vertices, wall.a1, wall.a2, wall.angle, false)

        wall.apply_width(direction)

        @symbols[wall.name].each do |symbol|
          symbol.finalize(direction + Math::PI, room.clockwise?)
          @symbol_pool.store symbol
        end
      end
    end
  end
end
