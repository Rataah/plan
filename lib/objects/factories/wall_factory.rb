module Plan
  class WallFactory
    def self.create(room, name, origin, length, angle, width)
      WallCache.create_and_store do |wall|
        wall.name = name
        wall.room_a = room
        wall.width = width

        # retrieve the angle
        wall.angle = (angle.is_a?(Symbol) ? ANGLE_SHORTCUTS[angle] : angle).rad
        wall.length = length

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

    def self.check_and_merge(room, name, origin_point, length, angle, width)
      new_walls = []
      wall_to_replace = nil

      WallCache.each do |wall|
        next unless wall.initialized?

        angle = (angle.is_a?(Symbol) ? ANGLE_SHORTCUTS[angle] : angle).rad
        if (origin_point.on_segment(wall.A1, wall.A2) || origin_point.on_segment(wall.B1, wall.B2)) &&
            (wall.angle == angle || ((wall.angle + Math::PI) % (2 * Math::PI)) == angle)

          origin_point.translate(*(wall.B1 - wall.A1).abs.xy) if origin_point.on_segment(wall.B1, wall.B2)
          end_point = origin_point.add(length * Math.cos(angle), length * Math.sin(angle)).round(2)
          pts = [wall.A1, wall.A2, origin_point, end_point].uniq.sort_by(&:dist)

          pts.each_cons(2).with_index do |(vertex1, vertex2), index|
            new_walls << Wall.new.tap do |new_wall|
              belongs_to_wall = vertex1.on_segment(wall.A1, wall.A2) || vertex2.on_segment(wall.A1, wall.A2)
              new_wall.name = "#{belongs_to_wall ? wall.name : name}_#{index}"
              new_wall.room_a = belongs_to_wall ? wall.room_a : room
              new_wall.room_b = room if belongs_to_wall
              new_wall.angle = wall.angle
              new_wall.width = width
              new_wall.merge!(wall)

              new_wall.vertex_a1 = vertex1
              new_wall.vertex_a2 = vertex2
            end
          end
          wall_to_replace = wall
        end
      end
      [new_walls, wall_to_replace]
    end
  end
end