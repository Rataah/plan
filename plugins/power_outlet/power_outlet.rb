class PowerOutletPlugin < Plan::WallPlugin
  def self.register
    { power_outlet: PowerOutlet }
  end

  def self.svg_include
    File.join(File.dirname(__FILE__), 'power_outlet.xml')
  end
end

class PowerOutlet < Plan::WallObject
  object 'wall-object-power-outlet'.freeze
end
