module Plan
  class WallCache
    def self.create_and_store
      wall = Wall.new
      yield wall if block_given?

      WallCache.hash[wall.name] = wall if wall.name
      wall
    end

    def self.contains?(wall_name)
      WallCache.hash.key? wall_name
    end

    def self.[](wall_name)
      WallCache.hash[wall_name]
    end

    def self.each
      WallCache.hash.each_value do |value|
        yield value
      end
    end

    private

    def self.hash
      @wall_cache ||= {}
    end
  end
end