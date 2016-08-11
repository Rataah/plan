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

    def self.check_and_merge(room, name, origin_point, length, angle, width)
      new_walls = []
      wall_to_replace = nil
      angle = (angle.is_a?(Symbol) ? ANGLE_SHORTCUTS[angle] : angle).rad

      WallCache.each do |wall|
        next unless wall.initialized?

        # translate the angle in rad

        # if the origin point is on the wall and the given angle is aligned with him, the 2 walls are mergeable
        if (origin_point.on_segment(wall.A1, wall.A2) || origin_point.on_segment(wall.B1, wall.B2)) &&
            (wall.angle == angle || ((wall.angle + Math::PI) % (2 * Math::PI)) == angle)

          # if the point is on the B segment, translate it on the A segment
          origin_point.translate(*(wall.B1 - wall.A1).abs.xy) if origin_point.on_segment(wall.B1, wall.B2)

          # calculate the end point from the given angle and length
          end_point = origin_point.add(length * Math.cos(angle), length * Math.sin(angle)).round(2)

          # sort the four points (2 from the first wall, 2 from the new wall)
          pts = [wall.A1, wall.A2, origin_point, end_point].uniq.sort do |pt1, pt2|
            pt1 -= origin_point
            pt2 -= origin_point

            pt1.x * Math.cos(-angle) - pt1.y * Math.sin(-angle) <=> pt2.x * Math.cos(-angle) - pt2.y * Math.sin(-angle)
          end

          # for each 2 consecutive point, create a new wall
          pts.each_cons(2).with_index do |(vertex1, vertex2), index|
            new_walls << Wall.new.tap do |new_wall|

              # is the wall belong to the first wall
              belongs_to_existing_wall = vertex1.on_segment(wall.A1, wall.A2) && vertex2.on_segment(wall.A1, wall.A2)
              # is the wall belong to the new wall
              belongs_to_new_wall = vertex1.on_segment(origin_point, end_point) && vertex2.on_segment(origin_point, end_point)

              new_wall.name = "#{belongs_to_existing_wall ? wall.name : name}_#{index}"
              new_wall.room_a = belongs_to_existing_wall ? wall.room_a : room
              new_wall.room_b = room if belongs_to_new_wall
              new_wall.angle = belongs_to_new_wall ? wall.angle : angle
              new_wall.width = width
              new_wall.merge!(wall)

              new_wall.vertex_a1 = vertex1.dup
              new_wall.vertex_a2 = vertex2.dup

            end
          end
          wall_to_replace = wall
        end
      end

      [new_walls, wall_to_replace]
    end
  end
end