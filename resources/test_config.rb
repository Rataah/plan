store(RoomFactory.create('dining room', 0, 0) do
  wall(368, :right, width: 5)
  wall(570, :down, width: 5)
  wall(368, :left, width: 5)
  wall(570, :up, name: 'dining_room_hall')
end)

store(RoomFactory.create('hall', anchor: WallPool['dining_room_hall'].b2) do
  wall(335, :left, width: 5)
  wall(182, :down, name: 'hall_toilets')
  wall(117, :right)
  wall(64, :up)
  wall(130, :right)
  wall(64, :down)
  wall(88, :right)
  wall(182, :up, name: 'dining_room_hall2')
end)

store(RoomFactory.create('toilets', anchor: WallPool['hall_toilets'].b1) do
  wall(85, :down, name: 'toilets_hall')
  wall(144, :left, name: 'toilets_bathroom')
  wall(85, :up, name: 'toilets_cmv')
  wall(144, :right, width: 5)
end)

store(RoomFactory.create('CMV', anchor: WallPool['toilets_cmv'].b2) do
  wall(85, :down)
  wall(49, :left)
  wall(85, :up, width: 5)
  wall(49, :right, width: 5)
end)

store(RoomFactory.create('bathroom', anchor: WallPool['toilets_bathroom'].b1) do
  wall(195, :left)
  wall(194, :down, width: 5)
  wall(175, :right, name: 'bathroom_bedroom')
  wall(69, :up)
  wall(20, :right)
  wall(125, :up, name: 'bathroom_hall')
end)

store(RoomFactory.create('bedroom', anchor: WallPool['bathroom_bedroom'].b1) do
  wall(175, :right, name: 'bathroom_bedroom2')
  wall(69, :up)
  wall(20, :right)
  wall(30, :up)
  wall(85, :right)
  wall(386, :down, name: 'bedroom_kitchen')
  wall(280, :left, width: 5)
  wall(287, :up, width: 5)
end)

store(RoomFactory.create('kitchen', anchor: WallPool['bedroom_kitchen'].b2) do
  wall(250, :right, width: 5)
  wall(386, :up, name: 'kitchen')
  wall(190, :left)
  wall(60, :down)
  wall(60, :left)
  wall(318, :down)
end)

store(RoomFactory.create('gas line', anchor: WallPool['bedroom_kitchen'].b1) do
  wall(58, :right)
  wall(58, :down)
  wall(58, :left)
  wall(58, :up)
end)