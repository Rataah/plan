module Plan
  class WallPool
    def self.create_and_store
      wall = Wall.new
      yield wall if block_given?

      WallPool.pool[wall.name] = wall if wall.name
      wall
    end

    def self.contains?(wall_name)
      WallPool.pool.key? wall_name
    end

    def self.[](wall_name)
      WallPool.pool[wall_name]
    end

    def self.all
      WallPool.pool.values
    end

    def self.each
      WallPool.pool.each_value do |value|
        yield value
      end
    end

    def self.add_link(room, wall, vertex1, vertex2)
      WallPool.link[room] ||= []
      WallPool.link[room] << WallLink.new(wall, vertex1, vertex2)
    end

    def self.walls(room)
      WallPool.link[room] ||= []
    end

    private

    def self.pool
      @wall_pool ||= {}
    end

    def self.link
      @wall_link ||= {}
    end
  end
end