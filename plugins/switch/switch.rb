class Switch < Plan::WallObject
  object 'wall-object-switch-simple'.freeze
end

class SwitchPlugin < Plan::WallPlugin
  register switch: Switch
  svg 'switch_simple.xml'
end
