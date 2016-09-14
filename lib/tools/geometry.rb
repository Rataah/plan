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

  # The Algorithm Design Manual by Steven S Skiena
  def self.position_against(point, segment_a, segment_b)
    -(segment_a.x * segment_b.y - segment_a.y * segment_b.x +
      segment_a.y * point.x - segment_a.x * point.y +
      segment_b.y * point.x - segment_b.x * point.y <=> 0.0)
  end

  def self.angle_aligned?(first_angle, second_angle)
    first_angle % (2 * Math::PI) - second_angle % (2 * Math::PI) < 1E-6 ||
      (first_angle + Math::PI) % (2 * Math::PI) - second_angle % (2 * Math::PI) < 1E-6
  end
end
