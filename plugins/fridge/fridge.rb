class FridgePlugin < Plan::RoomPlugin
  def self.register
    { fridge: Fridge }
  end

  def self.css_include
    File.join(File.dirname(__FILE__), 'fridge.css')
  end

  def self.svg_include
    File.join(File.dirname(__FILE__), 'fridge.xml')
  end
end

class Fridge < Plan::RoomObject
  object 'room-object-fridge'.freeze
  css 'fridge'.freeze
end
