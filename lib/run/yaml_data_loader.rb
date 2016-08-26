module Plan
  class YamlDataLoader

    def self.load_data_from_file(filename)
      require 'yaml'

      parse Plan.symbolize_keys(YAML::load(File.open(filename, encoding: "BOM|UTF-8", mode: 'rb')))
    end

    def self.parse(yaml_content)
      [].tap do |result|
        yaml_content[:rooms].each do |room_def|
          coordinates = room_def[:coordinates] || [nil, nil]
          anchor = nil

          if room_def.key? :anchor
            anchor_name, _, anchor_point = room_def[:anchor].rpartition('.')
            raise "Anchor #{anchor_name} not found" unless WallPool.contains? anchor_name
            raise 'Incorrect anchor point' unless %w(a1 a2 b1 b2).include? anchor_point

            anchor = WallPool[anchor_name].send(anchor_point.to_sym)
          end

          result << RoomFactory.create(room_def[:name], *coordinates, anchor: anchor) do
            room_def[:walls].each do |wall_def|
              width = wall_def[:width] || DEFAULT_WALL_WIDTH
              wall(wall_def[:length], wall_def[:direction].to_sym, width: width, name: wall_def[:name])
            end
          end
        end
      end
    end
  end
end