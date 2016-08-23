module Plan

  def self.merge_walls
    walls = WallPool.all
    walls.each do |wall|
      walls.select { |other_wall| other_wall != wall }.each do |other|
        if (wall.angle % (2 * Math::PI) == other.angle % (2 * Math::PI) || ((wall.angle + Math::PI) % (2 * Math::PI)) == other.angle % (2 * Math::PI)) &&
            wall.vertices.count { |vertex| vertex.on_segment(other.a1, other.a2) || vertex.on_segment(other.b1, other.b2)} >= 2
          Plan.log.debug("Wall links #{wall.name} - #{other.name}")

          [wall.ab1, wall.ab2, other.ab1, other.ab2].uniq!.sort_by!(&:dist).each_cons(2) do |segment|

          end
        end
      end
    end
  end
end