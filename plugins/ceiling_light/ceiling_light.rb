class CeilingLight < Plan::RoomObject
  object 'room-object-ceiling_light'.freeze

  def initialize(name, coordinates, _)
    super(name, coordinates, nil)
    @links = []
  end

  def link(object_name)
    @links << object_name
    self
  end

  def svg_elements(symbol_pool)
    elements = @links.map do |link|
      symbol = symbol_pool[link]
      Plan::SVGPath.curve(@coordinates, symbol.coordinates).fill('transparent').stroke('red')
    end
    (elements << super(symbol_pool))
  end
end

class CeilingLightPlugin < Plan::RoomPlugin
  register ceiling_light: CeilingLight
  svg 'ceiling_light.xml'
end
