class Bed < Plan::RoomObject
  object 'room-object-bed'.freeze
  css 'bed'.freeze
end

class BedPlugin < Plan::RoomPlugin
  register bed: Bed
  svg 'bed.xml'.freeze
  css 'bed.css'.freeze
end
