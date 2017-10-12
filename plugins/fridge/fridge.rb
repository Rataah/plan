class Fridge < Plan::RoomObject
  object 'room-object-fridge'.freeze
  css 'fridge'.freeze
end

class FridgePlugin < Plan::RoomPlugin
  register fridge: Fridge
  svg 'fridge.xml'.freeze
  css 'fridge.css'.freeze
end
