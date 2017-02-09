module Plan
  # Load and parse YAML config file
  class YamlDataLoader
    def self.parse(content, _)
      require 'yaml'

      yaml_content = Plan.symbolize_keys(YAML.safe_load(content))
      [].tap do |result|
        yaml_content[:floors].each do |floor_def|
          result << YamlFloorFactory.parse_floor(floor_def)
        end
      end
    end
  end
end
