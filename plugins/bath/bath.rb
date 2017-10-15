class Bath < Plan::RoomObject
  SIZE = Plan::Point.new(70, 170).freeze
  object 'room-object-bath'.freeze
  css 'bath'.freeze

  def size(x, y)
    @block_size = Plan::Point.new(x, y)
  end

  def svg_elements(symbol_pool)
    [
      Plan::SVGRect.new(*@coordinates.xy, *(@block_size || SIZE).xy).tap do |bath_block|
        bath_block.css_class('bath-block')
        bath_block.rotate(@rotation, *@coordinates.xy) if @rotation
      end,
      super(symbol_pool)
    ]
  end
end

class BathPlugin < Plan::RoomPlugin
  register bath: Bath
  svg 'bath.xml'.freeze
  css 'bath.css'.freeze
end
