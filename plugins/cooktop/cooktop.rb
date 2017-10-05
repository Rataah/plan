class CooktopPlugin < Plan::RoomPlugin
  def self.register
    { cooktop: Cooktop }
  end

  def self.css_include
    File.join(File.dirname(__FILE__), 'cooktop.css')
  end

  def self.svg_include
    File.join(File.dirname(__FILE__), 'cooktop.xml')
  end
end

class Cooktop < Plan::RoomObject
  object 'room-object-cooktop'.freeze
  css 'cooktop'.freeze
end
