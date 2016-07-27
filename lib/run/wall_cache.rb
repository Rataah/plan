module Plan
  class WallCache
    def self.store_wall(wall)
      @wall_cache ||= {}
      @wall_cache[wall.name] = wall
    end

    def self.[](wall_name)
      @wall_cache[wall_name]
    end
  end
end