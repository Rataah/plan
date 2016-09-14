module Plan
  # Wall factory. Create a wall
  class WallFactory
    def self.create(name, origin, length, angle, width, &block)
      WallFactory.new.instance_eval do
        Plan.log.debug("Creating new Wall:#{name}")
        @wall = WallPool.create_and_store do |wall|
          wall.name = name
          wall.width = width

          # retrieve the angle
          wall.angle = (angle.is_a?(Symbol) ? ANGLE_SHORTCUTS[angle] : angle).rad
          wall.length = length

        # compute the points
        wall.vertices_a = [origin.dup.round(2), origin.translate(wall.angle, wall.length).round(2)]
        end
        instance_eval &block if block_given?
        @wall
      end
    end

    def window(origin, length)
      @wall.windows << Window.new(origin, length)
    end
  end
end
