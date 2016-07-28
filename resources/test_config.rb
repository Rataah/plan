
store(Room.create('dining room', 0, 0) do
  wall(368, :right, width: 5).fill('blue')
  wall(570, :down, width: 5).fill('red')
  wall(368, :left, width: 5).fill('green')
  wall(570, :up, name: 'dining_room_hall')
end)

store(Room.create('hall', anchor: WallCache['dining_room_hall'].B2) do
  wall(335, :left, width: 5).fill('blue')
  wall(182, :down, name: 'hall_toilets')
  wall(117, :right)
  wall(64, :up)
  wall(130, :right)
  wall(64, :down)
  wall(88, :right)
  wall(182, :up)
end)

store(Room.create('toilets', *WallCache['hall_toilets'].B1.xy ) do
  wall(85, :down)
  wall(144, :left, name: 'toilets_bathroom')
  wall(85, :up, name: 'toilets_cmv')
  wall(144, :right, width: 5).fill('blue')
end)

store(Room.create('CMV', *WallCache['toilets_cmv'].B2.xy ) do
  wall(85, :down)
  wall(49, :left)
  wall(85, :up, width: 5).fill('yellow')
  wall(49, :right, width: 5).fill('blue')
end)

store(Room.create('bathroom', *WallCache['toilets_bathroom'].B1.xy ) do
  wall(195, :left)
  wall(194, :down, width: 5).fill('yellow')
  wall(175, :right, name: 'bathroom_bedroom')
  wall(69, :up)
  wall(20, :right)
end)

store(Room.create('bedroom', *WallCache['bathroom_bedroom'].B1.xy ) do
  wall(175, :right)
  wall(69, :up)
  wall(20, :right)
  wall(30, :up)
  wall(85, :right)
  wall(386, :down, name: 'bedroom_kitchen')
  wall(280, :left, width: 5).fill('green')
  wall(287, :up, width: 5).fill('yellow')
end)

store(Room.create('kitchen', *WallCache['bedroom_kitchen'].B2.xy) do
  wall(250, :right, width: 5).fill('green')
  wall(386, :up)
  wall(190, :left)
  wall(60, :down)
  wall(60, :left)
  wall(318, :down)
end)

store(Room.create('gas line', *WallCache['bedroom_kitchen'].B1.xy) do
  wall(58, :right)
  wall(58, :down)
  wall(58, :left)
  wall(58, :up)
end)