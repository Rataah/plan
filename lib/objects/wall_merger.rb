module Plan
  # Merge walls
  class WallMerger
    def merge_walls
      walls = WallPool.all
      walls.each do |wall|
        Plan.log.debug("Check #{wall.name}...")
        WallPool.all.select { |other_wall| other_wall != wall }.each do |other|
          # check if the 2 walls have to be merged
          next unless Plan.angle_aligned?(wall.angle, other.angle) &&
                      [wall.ab1, wall.ab2].count { |vertex| vertex.on_segment(other.ab1, other.ab2) }.nonzero?

          Plan.log.debug("Wall links #{wall.name} - #{other.name}")

          # retrieve all the couple of vertices (A/B) of the 2 walls and merge them.
          # the vertices are referenced by the center of the segment build with this 2 vertices
          indexed_points = wall.vertices_center.merge other.vertices_center do |_, wall_point, other_point|
            wall_point + other_point
          end

          # sort the centers
          sorted_points = sort_indexed_points(indexed_points, wall)

          # create the new wall
          merged_wall = build_wall(wall, other, sorted_points, indexed_points)

          rebuild_segments(merged_wall, wall, other, sorted_points)

          WallPool.delete(wall.name)
          WallPool.delete(other.name)
        end
      end
    end

    def sort_indexed_points(indexed_points, wall)
      indexed_points.keys.sort do |pt1, pt2|
        pt1 -= wall.ab1
        pt2 -= wall.ab1
        pt1.x * Math.cos(-wall.angle) - pt1.y * Math.sin(-wall.angle) <=>
          pt2.x * Math.cos(-wall.angle) - pt2.y * Math.sin(-wall.angle)
      end
    end

    def build_wall(wall, other, sorted_points, indexed_points)
      WallPool.create_and_store do |new_wall|
        new_wall.name = "#{wall.name}_#{other.name}"
        new_wall.width = wall.width
        new_wall.angle = wall.angle

        sorted_points.each do |point|
          ref_point = indexed_points[point].first.vertices.first
          is_vertex_b = (((sorted_points.last.x - sorted_points.first.x) * (ref_point.y - sorted_points.first.y) -
              (sorted_points.last.y - sorted_points.first.y) * (ref_point.x - sorted_points.first.x)) <=> 0.0) == 1

          if is_vertex_b
            new_wall.vertices_b << indexed_points[point].first.vertices.first.dup
            new_wall.vertices_a << indexed_points[point].first.vertices.last.dup
          else
            new_wall.vertices_a << indexed_points[point].first.vertices.first.dup
            new_wall.vertices_b << indexed_points[point].first.vertices.last.dup
          end
        end
      end
    end

    def rebuild_segments(merged_wall, wall, other, sorted_points)
      (WallPool.rooms(wall) + WallPool.rooms(other)).each do |room|
        side = Plan.position_against(room.center, sorted_points.first, sorted_points.last) == 1 ? :b : :a

        [WallPool.segment(room, wall), WallPool.segment(room, other)].compact.each do |wall_segment|
          vertex1 = sorted_points.index { |point| point == wall_segment.centers.first }
          vertex2 = sorted_points.index { |point| point == wall_segment.centers.last }

          new_segment = WallSegment.new(merged_wall,
                                        SegmentIndex.new(side, vertex1), SegmentIndex.new(side, vertex2))
          WallPool.replace_segment(room, wall_segment, new_segment)
        end
      end
    end
  end
end
