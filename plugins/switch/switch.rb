class SwitchPlugin < Plan::WallPlugin
  def self.register
    { switch: Switch }
  end

  def self.svg_include
    File.join(File.dirname(__FILE__), 'switch_simple.xml')
  end
end

class Switch < Plan::WallObject
  object 'wall-object-switch-simple'.freeze
end
