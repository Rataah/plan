module Plan
  def self.bounds(points)
    min_x = points.min_by(&:x).x
    min_y = points.min_by(&:y).y
    max_x = points.max_by(&:x).x
    max_y = points.max_by(&:y).y
    [Point.new(min_x, min_y), Point.new(max_x, max_y)]
  end

  def self.center(points)
    Plan.bounds(points).reduce(&:+) / 2
  end

  def self.point_in_polygon?(point, vertices)
    inside = false
    (vertices + [vertices.first]).each_cons(2) do |vertex1, vertex2|
      if (vertex1.y >= point.y) != (vertex2.y >= point.y) &&
         (point.x <= (vertex2.x - vertex1.x) * (point.y - vertex1.y) / (vertex2.y - vertex1.y) + vertex1.x)
        inside = !inside
      end
    end
    inside
  end

  def self.position_against(point, segment_a, segment_b)
    vector1 = segment_b - segment_a
    vector2 = segment_b - point
    -(vector1.x * vector2.y - vector1.y * vector2.x <=> 0.0)
  end

  def self.angle_aligned?(first_angle, second_angle)
    first_angle % (2 * Math::PI) - second_angle % (2 * Math::PI) < 1E-6 ||
      (first_angle + Math::PI) % (2 * Math::PI) - second_angle % (2 * Math::PI) < 1E-6
  end

  def self.normal_angle(vertices, vector1, vector2, angle, outside = true)
    center = Plan.center [vector1, vector2]
    normal = center.translate(angle + 90.rad, 0.1)
    if Plan.point_in_polygon?(normal, vertices) == outside
      angle - 90.rad
    else
      angle + 90.rad
    end
  end
end
