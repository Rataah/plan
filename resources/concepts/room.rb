floor('first') do
  room('1th', 0, 0) do
    wall(500, :right)
    wall(300, :down)
    wall(500, :left)
    wall(300, :up)
  end
end

floor('second') do
  room('2nd', 0, 0) do
    wall(245, :right)
    wall(300, :down, width: 10, name: '2nd_3rd')
    wall(245, :left)
    wall(300, :up)
  end

  room('3rd', anchor: '2nd_3rd.b1') do
    wall(245, :right)
    wall(300, :down)
    wall(245, :left)
    wall(300, :up, width: 10)
  end
end

floor('third') do
  room('4th', 0, 0) do
    wall(245, :right)
    wall(145, :down, width: 10, name: '4th_5th')
    wall(245, :left, width: 10, name: '4th_6th')
    wall(145, :up)
  end

  room('5th', anchor: '4th_5th.b1') do
    wall(245, :right)
    wall(145, :down)
    wall(245, :left, width: 10)
    wall(145, :up, width: 10)
  end

  room('6th', anchor: '4th_6th.b2') do
    wall(245, :right, width: 10)
    wall(145, :down, width: 10, name: '6th_7th')
    wall(245, :left)
    wall(145, :up)
  end

  room('7th', anchor: '6th_7th.b1') do
    wall(245, :right, width: 10)
    wall(145, :down)
    wall(245, :left)
    wall(145, :up, width: 10)
  end
end
