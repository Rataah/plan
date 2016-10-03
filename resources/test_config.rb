room('dining room', 0, 0) do
  wall(368, :right, width: 15)
  wall(570, :down, width: 15)
  wall(368, :left, width: 15) do
    window(60, 245).casement(80, origin: 82.5).casement(80, reverse: true)
  end
  wall(570, :up, name: 'dining_room_hall') do
    door(440, 130).casement(41, origin: 2).casement(80, reverse: true)
  end
end

room('hall', anchor: 'dining_room_hall.b2') do
  wall(335, :left, width: 15) do
    door(117, 102).casement(92, origin: 5, outside: true, reverse: true)
  end
  wall(182, :down, name: 'hall_toilets')
  wall(117, :right)
  wall(64, :up)
  wall(130, :right)
  wall(64, :down)
  wall(88, :right) do
    door(1, 86).casement(84, origin: 1, reverse: true)
  end
  wall(182, :up, name: 'dining_room_hall2')
end

room('toilets', anchor: 'hall_toilets.b1') do
  wall(85, :down, name: 'toilets_hall') do
    door(1, 83).casement(81, origin: 1, outside: true)
  end
  wall(144, :left, name: 'toilets_bathroom')
  wall(85, :up, name: 'toilets_cmv')
  wall(144, :right, width: 15)
end

room('CMV', anchor: 'toilets_cmv.b2') do
  wall(85, :down)
  wall(49, :left)
  wall(85, :up, width: 15)
  wall(49, :right, width: 15)
end

room('bathroom', anchor: 'toilets_bathroom.b1') do
  wall(198, :left)
  wall(194, :down, width: 15)
  wall(178, :right, name: 'bathroom_bedroom')
  wall(69, :up)
  wall(20, :right)
  wall(125, :up, name: 'bathroom_hall') do
    door(41, 83).casement(81, origin: 1)
  end
end

room('bedroom', anchor: 'bathroom_bedroom.b1') do
  wall(183, :right, name: 'bathroom_bedroom2')
  wall(69, :up)
  wall(20, :right)
  wall(33, :up)
  wall(80, :right) do
    door(1, 78).casement(76, origin: 1, reverse: true)
  end
  wall(383, :down, name: 'bedroom_kitchen')
  wall(283, :left, width: 15) do
    window(21, 110).casement(100, origin: 5)
  end
  wall(281, :up, width: 15)
end

room('kitchen', anchor: 'bedroom_kitchen.b2') do
  wall(250, :right, width: 15) do
    window(118, 110).casement(100, origin: 5, reverse: true, outside: true)
  end
  wall(383, :up, name: 'kitchen') do
    door(90, 88).casement(86)
  end
  wall(190, :left)
  wall(60, :down)
  wall(60, :left)
  wall(323, :down)
end

room('gas line', anchor: 'bedroom_kitchen.b1') do
  wall(55, :right)
  wall(55, :down)
  wall(55, :left)
  wall(55, :up)
end
