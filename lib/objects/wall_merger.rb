module Plan
  # Merge walls
  class WallMerger
    def merge_walls
      WallPool.all.each do |wall|
        next unless WallPool.contains? wall.name

        WallPool.without(wall).each do |other|
          # check if the 2 walls have to be merged
          next unless wall.aligned?(other) && wall.intersect?(other)
          Plan.log.debug("Wall links #{wall.name} - #{other.name}")

          # retrieve all the couple of vertices (A/B) of the 2 walls and merge them.
          # the vertices are referenced by the center of the segment build with this 2 vertices
          indexed_points = wall.vertices_center.merge other.vertices_center do |_, wall_point, other_point|
            wall_point + other_point
          end

          # sort the centers
          sorted_points = sort_indexed_points(indexed_points, wall.ab1, -wall.angle)

          # create the new wall
          merged_wall = build_wall(wall, other, sorted_points, indexed_points)

          rebuild_segments(merged_wall, wall, other, sorted_points)
          WallPool.delete(wall.name, other.name)
          break
        end
      end
    end

    def sort_indexed_points(indexed_points, origin, angle)
      indexed_points.keys.sort do |left_point, right_point|
        comparator(left_point - origin, right_point - origin, Math.cos(angle), Math.sin(angle))
      end
    end

    def comparator(left_point, right_point, cos_angle, sin_angle)
      left_point.x * cos_angle - left_point.y * sin_angle <=> right_point.x * cos_angle - right_point.y * sin_angle
    end

    def build_wall(wall, other, sorted_points, indexed_points)
      WallPool.create_and_store do |new_wall|
        new_wall.name = "#{wall.name}_#{other.name}"
        new_wall.width = wall.width
        new_wall.angle = wall.angle

        sorted_points.each do |point|
          add_vertices(new_wall, sorted_points, *indexed_points[point].first.vertices.first_and_last.deep_dup)
        end

        add_openings(new_wall, wall)
        add_openings(new_wall, other)
      end
    end

    def add_openings(wall, new_wall)
      wall.windows.each do |window|
        window.origin += wall.ab1.dist new_wall.ab1
        new_wall.windows << window
      end

      wall.doors.each do |door|
        door.origin += wall.ab1.dist new_wall.ab1
        new_wall.doors << door
      end
    end

    def add_vertices(wall, segment, first_ref_point, last_ref_point)
      if Plan.position_against(first_ref_point, segment.first, segment.last) == 1
        wall.vertices_b << first_ref_point
        wall.vertices_a << last_ref_point
      else
        wall.vertices_a << first_ref_point
        wall.vertices_b << last_ref_point
      end
    end

    def rebuild_segments(merged_wall, wall, other, sorted_points)
      (WallPool.rooms(wall) + WallPool.rooms(other)).each do |room|
        room_vertices = room.vertices.uniq
        [WallPool.segment(room, wall), WallPool.segment(room, other)].compact.each do |wall_segment|
          start_vertex = sorted_points.index { |point| point == wall_segment.centers.first }
          end_vertex = sorted_points.index { |point| point == wall_segment.centers.last }

          side_angle = Plan.normal_angle(
            [merged_wall.a1, merged_wall.a2, merged_wall.b2, merged_wall.b1],
            merged_wall.vertices_a[start_vertex], merged_wall.vertices_a[end_vertex], merged_wall.angle
          )
          side_a = Plan.center [merged_wall.vertices_a[start_vertex], merged_wall.vertices_a[end_vertex]]
          side = Plan.point_in_polygon?(side_a.translate(side_angle, merged_wall.width / 2.0), room_vertices) ? :a : :b

          new_segment = WallSegment.new(
            merged_wall,
            SegmentIndex.new(side, start_vertex), SegmentIndex.new(side, end_vertex),
            wall_segment.angle
          )
          WallPool.replace_segment(room, wall_segment, new_segment)
        end
      end
    end
  end
end
