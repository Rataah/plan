class Block < Plan::RoomObject
  attr_accessor :width, :height

  def initialize(coordinates, width, height)
    @name = nil
    @coordinates = coordinates
    @width = width
    @height = height
  end

  def text(value, rotation = nil)
    @text = value
    @text_rotation = rotation
  end

  def self.create_from_room(room, coordinate_x, coordinate_y, width, height)
    new(room.min_bound.add(coordinate_x, coordinate_y), width, height)
  end

  def svg_elements(_)
    [
      Plan::SVGRect.new(*@coordinates.xy, @width, @height).css_class('block'),
      svg_text
    ].compact
  end

  def svg_text
    return nil unless @text
    text_coordinates = @coordinates.add(@width / 2.0, @height / 2.0)
    Plan::SVGText.new(@text, text_coordinates).tap do |svg_text|
      svg_text.anchor('middle')
      svg_text.rotate(@text_rotation, *text_coordinates.xy) if @text_rotation
    end
  end
end

class BlockPlugin < Plan::RoomPlugin
  register block: Block
  css 'block.css'
end
