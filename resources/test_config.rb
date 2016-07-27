
store(Room.create('salle a manger', 0, 0) do
  wall(368, :right)
  wall(570, :down)
  wall(368, :left)
end)

store(Room.create('hall', 0, 0) do
  wall(335, :left)
  wall(182, :down)
  wall(117, :right)
  wall(64, :up)
  wall(130, :right)
  wall(64, :down)
  wall(88, :right)
end)

store(Room.create('cuisine', 0, 182) do
  wall(388, :down)
  wall(250, :left)
  wall(328, :up)
  wall(60, :right)
  wall(60, :up)
end)

store(Room.create('wc', -335, 0 ) do
  wall(144, :left)
  wall(85, :down)
  wall(144, :right)
end)

store(Room.create('salle de bains', -335, 85 ) do
  wall(195, :left)
  wall(194, :down)
  wall(175, :right)
  wall(69, :up)
  wall(20, :right)
end)

store(Room.create('chambre', -250,  570) do
  wall(280, :left)
  wall(291, :up)
  wall(175, :right)
  wall(69, :up)
  wall(20, :right)
  wall(28, :up)
  wall(85, :right)
end)