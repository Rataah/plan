module Plan
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
        wall.vertex_a1 = origin.dup.round(2)
        wall.vertex_a2 = wall.vertex_a1.add(length * Math.cos(wall.angle), length * Math.sin(wall.angle)).round(2)
      end
    end
  end
end