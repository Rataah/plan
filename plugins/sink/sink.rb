class Sink < Plan::RoomObject
  object 'room-object-sink'.freeze
  css 'sink'.freeze
end

class SinkPlugin < Plan::RoomPlugin
  register sink: Sink
  svg 'sink.xml'
  css 'sink.css'
end
