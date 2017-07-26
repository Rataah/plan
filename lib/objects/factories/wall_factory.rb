module Plan
  # Wall factory. Create a wall
  class WallFactory
    def self.create(wall_pool, name, origin, length, angle, width, &block)
      WallFactory.new(wall_pool).instance_eval do
        Plan.log.debug("Creating new Wall:#{name}")
        @wall = @wall_pool.create_and_store do |wall|
          wall.name = name
          wall.width = width

          # retrieve the angle
          wall.angle = (angle.is_a?(Symbol) ? ANGLE_SHORTCUTS[angle] : angle).rad
          wall.length = length

          # compute the points
          wall.vertices_a = [origin.dup, origin.translate(wall.angle, wall.length)]
        end
        instance_eval(&block) if block_given?
        @wall
      end
    end

    def initialize(wall_pool)
      @wall_pool = wall_pool
    end

    def window(origin, length)
      (@wall.windows << Window.new(origin, length)).last
    end

    def door(origin, length)
      (@wall.doors << Door.new(origin, length)).last
    end
  end
end
