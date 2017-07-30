module Plan
  # Merge walls
  class WallMerger
    def initialize(wall_pool)
      @wall_pool = wall_pool
    end

    def merge_walls
      @wall_pool.all.combination(2) do |wall, other|
        # not yet in pool
        next unless @wall_pool.contains? wall.name
        merge_wall(wall, other) if wall.aligned?(other) && wall.intersect?(other)
      end
    end

    def merge_wall(wall, other)
      Plan.log.debug("Wall links #{wall} - #{other}")

      # retrieve all the couple of vertices (A/B) of the 2 walls and merge them.
      # the vertices are referenced by the center of the segment build with this 2 vertices
      indexed_points = wall.vertices_center.merge other.vertices_center do |_, wall_point, other_point|
        wall_point + other_point
      end

      # sort the centers
      sorted_points = WallMerger.sort_indexed_points(indexed_points, wall.ab1, -wall.angle)

      # create the new wall
      merged_wall = build_wall(wall, other, sorted_points, indexed_points)

      rebuild_segments(merged_wall, wall, other, sorted_points)
      @wall_pool.delete(wall.name, other.name)
    end

    def self.sort_indexed_points(indexed_points, origin, angle)
      indexed_points.keys.sort do |left_point, right_point|
        WallMerger.comparator(left_point - origin, right_point - origin, Math.cos(angle), Math.sin(angle))
      end
    end

    def self.comparator(left_point, right_point, cos_angle, sin_angle)
      left_point.orientation(cos_angle, sin_angle) <=> right_point.orientation(cos_angle, sin_angle)
    end

    def build_wall(wall, other, sorted_points, indexed_points)
      @wall_pool.create_and_store do |new_wall|
        new_wall.name = "#{wall}_#{other}"
        new_wall.width = wall.width
        new_wall.angle = wall.angle

        new_wall.rooms_coordinates = wall.rooms_coordinates.merge(other.rooms_coordinates)

        sorted_points.each do |point|
          add_vertices(new_wall, sorted_points,
                       *indexed_points[point].first.vertices.first_and_last.deep_dup)
        end
        WallMerger.add_openings(wall, new_wall)
        WallMerger.add_openings(other, new_wall)
      end
    end

    def self.add_openings(wall, new_wall)
      translation = wall.ab1.dist new_wall.ab1
      new_wall.windows.concat(wall.windows.map { |window| window.translate(translation) })
      new_wall.doors.concat(wall.doors.map { |door| door.translate(translation) })
    end

    def add_vertices(wall, segment, first_ref_point, last_ref_point)
      if Plan.position_against(first_ref_point, segment.first, segment.last).one?
        wall.vertices_b << first_ref_point
        wall.vertices_a << last_ref_point
      else
        wall.vertices_a << first_ref_point
        wall.vertices_b << last_ref_point
      end
    end

    def rebuild_segments(merged_wall, wall, other, sorted_points)
      @wall_pool.rooms(wall, other).each do |room|
        @wall_pool.segments(room, wall, other).each do |wall_segment|
          start_vertex, end_vertex = sorted_points.indexes(wall_segment.centers.first_and_last)

          wall_side = merged_wall.side(room.vertices, start_vertex, end_vertex)
          new_segment = WallSegment.new(
            merged_wall,
            SegmentIndex.new(wall_side, start_vertex), SegmentIndex.new(wall_side, end_vertex),
            wall_segment.angle
          )
          @wall_pool.replace_segment(room, wall_segment, new_segment)
        end
      end
    end
  end
end
