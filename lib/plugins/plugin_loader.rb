module Plan
  class PluginLoader
    def self.load_plugins
      Dir[File.join(Plan::ROOT, 'plugins/**/*.rb')].each { |f| require f }
    end

    def self.room_plugin_methods
      Plan.descendants(RoomPlugin).map(&:registration).reduce(&:merge)
    end

    def self.wall_plugin_methods
      Plan.descendants(WallPlugin).map(&:registration).reduce(&:merge)
    end

    def self.svg_includes
      [Plan.descendants(RoomPlugin) + Plan.descendants(WallPlugin)]
        .flatten
        .select { |plugin| plugin.svg_file }
        .map(&:svg_file).compact.flatten.sort
    end

    def self.css_includes
      [Plan.descendants(RoomPlugin) + Plan.descendants(WallPlugin)]
        .flatten
        .select { |plugin| plugin.css_file }
        .map(&:css_file).compact.flatten.sort
    end
  end
end
