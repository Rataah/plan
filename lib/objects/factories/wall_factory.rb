module Plan
  class WallFactory
    def self.create(room, name, origin, length, angle, width)
      WallCache.create_and_store do |wall|
        wall.name = name
        wall.room_a = room

        # retrieve the angle
        wall.angle = (angle.is_a?(Symbol) ? ANGLE_SHORTCUTS[angle] : angle).rad
        wall.length = length
        wall.width = width

        # compute the points
        wall.vertex_a1 = origin.dup.round(2)
        wall.vertex_a2 = wall.vertex_a1.add(length * Math.cos(wall.angle), length * Math.sin(wall.angle)).round(2)
      end
    end

    def self.connect(room, name, wall1, wall2, width)
      WallCache.create_and_store do |wall|
        wall.name = name
        wall.room_a = room
        wall.width = width

        wall.vertex_a1 = wall1.A2.dup.round(2)
        wall.vertex_a2 = wall2.A1.dup.round(2)

        wall.length = wall.vertex_a1.dist wall.vertex_a2
        wall.angle = Math.atan2(*(wall.vertex_a1 - wall.vertex_a2).xy).round(2)
      end
    end

    def self.check_and_merge(room, name, origin, length, angle, width)
      WallCache.each do |wall|
        next unless wall.initialized?

        angle = (angle.is_a?(Symbol) ? ANGLE_SHORTCUTS[angle] : angle).rad
        if (origin.on_segment(wall.A1, wall.A2) || origin.on_segment(wall.B1, wall.B2)) &&
            (wall.angle == angle || ((wall.angle + Math::PI) % (2 * Math::PI)) == angle)
          origin.translate(*(wall.B1 - wall.A1).xy) if origin.on_segment(wall.B1, wall.B2)
          pts = [wall.A1, wall.A2, origin,
                 origin.add(length * Math.cos(angle), length * Math.sin(angle)).round(2)].sort_by(&:dist)
        end
      end
    end
  end
end