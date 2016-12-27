module Plan
  # Load and parse YAML config file
  class YamlDataLoader
    def self.parse(content, _)
      require 'yaml'

      yaml_content = Plan.symbolize_keys(YAML.load(content))
      [].tap do |result|
        yaml_content[:rooms].each do |room_def|
          result << YamlRoomFactory.parse_room(room_def)
        end
      end
    end
  end
end
