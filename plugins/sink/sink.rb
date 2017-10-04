class SinkPlugin < Plan::RoomPlugin
  def self.register
    { sink: Sink }
  end

  def self.css_include
    File.join(File.dirname(__FILE__), 'sink.css')
  end

  def self.svg_include
    File.join(File.dirname(__FILE__), 'sink.xml')
  end
end

class Sink < Plan::RoomObject
  object 'room-object-sink'.freeze
  css 'sink'.freeze
end
