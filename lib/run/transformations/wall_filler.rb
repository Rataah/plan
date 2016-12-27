module Plan
  # fill walls
  class WallFiller
    def self.fill_walls
      WallPool.all.each do |wall|
        next unless WallPool.contains? wall.name

        WallPool.without(wall).each do |other|
          # check if the 2 walls have to be merged
          next unless (wall.bounds & other.bounds).count == 1
          WallFiller.add_wall(wall, other)
        end
      end
    end

    def self.add_wall(wall, other)
      shared_vertex = (wall.bounds & other.bounds).first
      corner_wall_point = wall.cross_point(shared_vertex)
      corner_other_point = other.cross_point(shared_vertex)

      center = Plan.center(shared_vertex, corner_wall_point, corner_other_point)
      return unless WallPool.wall_at_position(center).nil?

      WallPool.create_and_store do |corner_wall|
        corner_wall.name = "corner_#{wall.name}_#{other.name}"
        corner_wall.angle = wall.angle
        corner_wall.width = wall.width
        corner_wall.vertices_a.push(shared_vertex.dup, corner_other_point.dup)

        fourth_point = corner_wall_point + (corner_other_point - shared_vertex)
        corner_wall.vertices_b.push(corner_wall_point.dup, fourth_point)
      end
    end
  end
end
