
store(Room.create('salle a manger', 0, 0) do
  wall(368, :right, width: 5)
  wall(570, :down, width: 5)
  wall(368, :left, width: 5)
  wall(570, :up, name: 'sam_hall')
end)

store(Room.create('hall', *WallCache['sam_hall'].B2.xy) do
  wall(335, :left, name: 'hall_ext', width: 5)
  wall(182, :down, name: 'hall_wc')
  wall(117, :right)
  wall(64, :up)
  wall(130, :right)
  wall(64, :down)
  wall(88, :right, name: 'hall_cuisine')
  wall(182, :up)
end)

store(Room.create('wc', *WallCache['hall_wc'].B1.xy ) do
  wall(85, :down)
  wall(144, :left, name: 'wc_sdb')
  wall(85, :up, width: 5)
  wall(144, :right, width: 5)
end)

store(Room.create('salle de bains', *WallCache['wc_sdb'].B1.xy ) do
  wall(195, :left)
  wall(194, :down, width: 5)
  wall(175, :right, name: 'sdb_chb')
  wall(69, :up)
  wall(20, :right)
end)

store(Room.create('chambre', *WallCache['sdb_chb'].B1.xy ) do
  wall(175, :right)
  wall(69, :up)
  wall(20, :right)
  wall(30, :up)
  wall(85, :right)
  wall(386, :down, name: 'chb_cuisine')
  wall(280, :left, width: 5)
  wall(287, :up, width: 5)
end)

store(Room.create('cuisine', *WallCache['chb_cuisine'].B2.xy) do
  wall(250, :right, width: 5)
  wall(386, :up)
  wall(190, :left)
  wall(60, :down)
  wall(60, :left)
  wall(318, :down)
end)
