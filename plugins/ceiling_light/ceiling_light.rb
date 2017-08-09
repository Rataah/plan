class CeilingLightPlugin < Plan::RoomPlugin
  def self.register
    { ceiling_light: CeilingLight }
  end

  def self.svg_include
    File.join(File.dirname(__FILE__), 'ceiling_light.xml')
  end
end

class CeilingLight < Plan::RoomObject
  object 'room-object-ceiling_light'.freeze

  def initialize(name, coordinates)
    super(name, coordinates)
    @links = []
  end

  def link(object_name)
    @links << object_name
    self
  end

  def svg_elements(symbol_pool)
    elements = @links.map do |link|
      symbol = symbol_pool[link]
      SVGPath.curve(@coordinates, symbol.coordinates).fill('transparent').stroke('red')
    end
    (elements << super(symbol_pool))
  end
end
