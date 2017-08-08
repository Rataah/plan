module Plan
  # Helper methods for a wall
  module WallHelper
    def aligned?(other)
      Plan.angle_aligned?(angle, other.angle)
    end

    def intersect?(other)
      [ab1, ab2].count { |vertex| vertex.on_segment(other.ab1, other.ab2) } > 0
    end

    def side(vertices, start_index, end_index)
      center = Plan.center(vertices_a.values_at(start_index, end_index))
      outside_angle = angle + Plan.normal_angle(bounds, a1, a2, angle, false)
      Plan.point_in_polygon?(center.translate(outside_angle, 1), vertices) ? :a : :b
    end

    def cross_point(point)
      if vertices_a.include? point
        vertices_b.at(vertices_a.index(point))
      else
        vertices_a.at(vertices_b.index(point))
      end
    end
  end
end
