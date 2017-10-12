class Cooktop < Plan::RoomObject
  object 'room-object-cooktop'.freeze
  css 'cooktop'.freeze
end

class CooktopPlugin < Plan::RoomPlugin
  register cooktop: Cooktop
  svg 'cooktop.xml'.freeze
  css 'cooktop.css'.freeze
end
