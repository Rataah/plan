module Plan
  # Load and parse YAML config file
  class YamlDataLoader
    def self.load_data_from_file(filename)
      require 'yaml'
      parse Plan.symbolize_keys(YAML.load(File.open(filename, encoding: 'BOM|UTF-8', mode: 'rb')))
    end

    def self.parse(yaml_content)
      [].tap do |result|
        yaml_content[:rooms].each do |room_def|
          result << YamlRoomFactory.parse_room(room_def)
        end
      end
    end
  end
end
