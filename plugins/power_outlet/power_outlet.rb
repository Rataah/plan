class PowerOutlet < Plan::WallObject
  object 'wall-object-power-outlet'.freeze
  css 'power-outlet'.freeze
end

class PowerOutletPlugin < Plan::WallPlugin
  register power_outlet: PowerOutlet
  svg 'power_outlet.xml'.freeze
  css 'power_outlet.css'.freeze
end
