require_relative '../../lib/plan'

module Plan

  rooms = []
  rooms << Room.new.create('salle a manger', 0, 0) do
    wall(368, :right).width(5)
    wall(570, :down).width(5)
    wall(368, :left).width(5)
  end

  rooms << Room.new.create('hall', 0, 0) do
    wall(335, :left).width(5)
    wall(182, :down)
    wall(117, :right)
    wall(64, :up)
    wall(130, :right)
    wall(64, :down)
    wall(88, :right)
  end

  rooms << Room.new.create('cuisine', 0, 182) do
    wall(388, :down)
    wall(250, :left).width(5)
    wall(328, :up)
    wall(60, :right)
    wall(60, :up)
  end

  rooms << Room.new.create('wc', -335, 0 ) do
    wall(144, :left).width(5)
    wall(85, :down)
    wall(144, :right)
  end

  rooms << Room.new.create('salle de bains', -335, 85 ) do
    wall(195, :left)
    wall(194, :down).width(5)
    wall(175, :right)
    wall(69, :up)
    wall(20, :right)
  end

  rooms << Room.new.create('chambre', -250,  570) do
    wall(280, :left).width(5)
    wall(291, :up).width(5)
    wall(175, :right)
    wall(69, :up)
    wall(20, :right)
    wall(28, :up)
    wall(85, :right)
  end

  min_vertex, max_vertex = Plan.bounds(rooms.map(&:vertices).flatten)

  rooms.each { |room| room.translate(-min_vertex.x + 50, -min_vertex.y + 50) }
  svg = SVG.new

  rooms.each {|room| room.svg_elements.each {|line| svg.contents << line}}
  svg.contents << SVGText.new("Total: #{rooms.map(&:area).reduce(0,:+)} m²", max_vertex.x + 50, max_vertex.y + 150)
  svg.write File.new('test.svg', 'w')
end
