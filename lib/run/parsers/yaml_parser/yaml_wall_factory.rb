module Plan
  class YamlWallFactory
    def self.parse_wall(wall_name, last_point, wall_def)
      setup_default(wall_def)

      WallFactory.create(wall_name, last_point, wall_def[:length], wall_def[:direction], wall_def[:width]) do
        YamlWallFactory.parse_openings(self, :window, wall_def[:windows]) if wall_def.key? :windows
        YamlWallFactory.parse_openings(self, :door, wall_def[:doors]) if wall_def.key? :doors
      end
    end

    def self.parse_openings(wall_factory, method, openings)
      openings.each do |opening_def|
        opening = wall_factory.send(method, opening_def[:origin], opening_def[:length])
        opening_def[:casements].each do |casement_def|
          opening.casement(casement_def[:length], casement_def.slice(:reverse, :origin, :angle, :outside))
        end if opening_def.key? :casements
      end
    end

    def self.setup_default(wall_def)
      wall_def[:width] = wall_def[:width] || DEFAULT_WALL_WIDTH
      wall_def[:direction] = wall_def[:direction].to_sym if wall_def[:direction].is_a? String
    end
  end
end
