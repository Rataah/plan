class Toilet < Plan::RoomObject
  object 'room-object-toilet'.freeze
  css 'toilet'.freeze
end

class ToiletPlugin < Plan::RoomPlugin
  register toilet: Toilet
  svg 'toilet.xml'.freeze
  css 'toilet.css'.freeze
end
