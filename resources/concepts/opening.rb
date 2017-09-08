metadata {
  title 'Opening'
  author 'Rataah'
  version '0.1.0'
}

floor('floor') {
  room('room1', 0, 0) {
    wall(1050, :right)
    wall(200, :down) {
      door(10, 180).casement(80, origin: 10)
    }
    wall(1050, :left, name: 'room1_wall') {
      door(10, 180).casement(80, origin: 10).casement(80, reverse: true)
      door(205, 100).casement(80, origin: 10, outside: true)
      window(310, 100).casement(80, origin: 10, reverse: true, outside: true)
      window(415, 100).casement(80, origin: 10, reverse: true)
    }
    wall(200, :up) {
      door(10, 180).casement(80, origin: 10)
    }
  }

  room('room2', anchor: 'room1_wall.b1') {
    wall(1050, :left) {
      door(610, 180).casement(80, origin: 10).casement(80, reverse: true)
      door(805, 100).casement(80, origin: 10, outside: true)
      window(910, 100).casement(80, origin: 10, reverse: true, outside: true)
      window(1015, 100).casement(80, origin: 10, reverse: true)
    }
    wall(200, :down) {
      door(10, 180).casement(80, origin: 10)
    }
    wall(1050, :right)
    wall(200, :up) {
      door(10, 180).casement(80, origin: 10)
    }
  }
}
