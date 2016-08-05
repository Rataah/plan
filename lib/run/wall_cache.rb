module Plan
  class WallCache
    def self.create_and_store
      @wall_cache ||= {}

      wall = Wall.new
      yield wall if block_given?

      @wall_cache[wall.name] = wall if wall.name
      wall
    end

    def self.contains?(wall_name)
      @wall_cache.key? wall_name
    end

    def self.[](wall_name)
      @wall_cache[wall_name]
    end
  end
end