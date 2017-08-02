module Plan
  # fill walls
  class WallFiller
    def initialize(wall_pool)
      @wall_pool = wall_pool
    end

    def fill_walls
      @wall_pool.all.each do |wall|
        next unless @wall_pool.contains? wall.name

        @wall_pool.without(wall).each do |other|
          # check if the 2 walls have to be merged
          next unless (wall.bounds & other.bounds).one?
          add_wall(wall, other)
        end
      end
    end

    def add_wall(wall, other)
      shared_vertex = (wall.bounds & other.bounds).first
      corner_wall_point = wall.cross_point(shared_vertex)
      corner_other_point = other.cross_point(shared_vertex)

      center = Plan.center(shared_vertex, corner_wall_point, corner_other_point)
      return if @wall_pool.wall_at_position(center)

      @wall_pool.create_and_store do |corner_wall|
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
