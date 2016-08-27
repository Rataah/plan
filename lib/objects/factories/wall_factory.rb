module Plan
  # Wall factory. Create a wall
  class WallFactory
    def self.create(name, origin, length, angle, width)
      Plan.log.debug("Creating new Wall:#{name}")
      WallPool.create_and_store do |wall|
        wall.name = name
        wall.width = width

        # retrieve the angle
        wall.angle = (angle.is_a?(Symbol) ? ANGLE_SHORTCUTS[angle] : angle).rad
        wall.length = length

        # compute the points
        wall.vertices_a = [origin.dup.round(2),
                           origin.add(length * Math.cos(wall.angle), length * Math.sin(wall.angle)).round(2)]
      end
    end
  end
end
