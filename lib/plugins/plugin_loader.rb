module Plan
  class PluginLoader
    def self.load_plugins
      Dir[File.join(Plan::ROOT, 'plugins/**/*.rb')].each { |f| require f }
    end

    def self.room_plugin_methods
      Plan.descendants(RoomPlugin).map(&:register).reduce(&:merge)
    end

    def self.wall_plugin_methods
      Plan.descendants(WallPlugin).map(&:register).reduce(&:merge)
    end

    def self.svg_includes
      [Plan.descendants(RoomPlugin) + Plan.descendants(WallPlugin)]
        .flatten
        .select { |plugin| plugin.respond_to?(:svg_include) }
        .map(&:svg_include).compact.flatten
    end

    def self.css_includes
      [Plan.descendants(RoomPlugin) + Plan.descendants(WallPlugin)]
        .flatten
        .select { |plugin| plugin.respond_to?(:css_include) }
        .map(&:css_include).compact.flatten
    end
  end
end
