metadata {
  title 'Apartment'
  author 'Rataah'
  version '0.1.0'
}

floor('apartment') {
  room('dining room', 0, 0) {
    wall(368, :right, width: 15)
    wall(570, :down, width: 15)
    wall(368, :left, width: 15) {
      window(60, 245).casement(80, origin: 82.5).casement(80, reverse: true)
    }
    wall(570, :up, name: 'dining_room_hall') {
      door(440, 130).casement(41, origin: 2).casement(80, reverse: true)
      switch('dining_room_switch_1', 185)
      switch('dining_room_switch_2', 420)
    }

    ceiling_light('dining_ceiling_light', 180, 280).link('dining_room_switch_1').link('dining_room_switch_2')
  }

  room('hall', anchor: 'dining_room_hall.b2') {
    wall(335, :left, width: 15) {
      door(117, 102).casement(92, origin: 5, reverse: true)
      switch('hall_switch_1', 100)
    }
    wall(182, :down, name: 'hall_toilets')
    wall(117, :right) {
      switch('hall_switch_2', 95)
    }
    wall(64, :up)
    wall(130, :right)
    wall(64, :down) {
      switch('hall_switch_3', 30)
    }
    wall(88, :right) {
      door(1, 86).casement(84, origin: 1, reverse: true, outside: true)
    }
    wall(182, :up, name: 'dining_room_hall2')
  }

  room('toilets', anchor: 'hall_toilets.b1') {
    wall(85, :down, name: 'toilets_hall') {
      door(1, 83).casement(81, origin: 1, outside: true)
    }
    wall(144, :left, name: 'toilets_bathroom') {
      switch('toilets_switch', 15)
    }
    wall(85, :up, name: 'toilets_cmv')
    wall(144, :right, width: 15)
  }

  room('CMV', anchor: 'toilets_cmv.b2') {
    wall(85, :down)
    wall(49, :left)
    wall(85, :up, width: 15)
    wall(49, :right, width: 15)
  }

  room('bathroom', anchor: 'toilets_bathroom.b1') {
    wall(198, :left) {
      switch('bathroom_switch', 15)
    }
    wall(194, :down, width: 15)
    wall(178, :right, name: 'bathroom_bedroom')
    wall(69, :up)
    wall(20, :right)
    wall(125, :up, name: 'bathroom_hall') {
      door(41, 83).casement(81, origin: 1, outside: true)
    }
  }

  room('bedroom', anchor: 'bathroom_bedroom.b1') {
    wall(183, :right, name: 'bathroom_bedroom2')
    wall(69, :up)
    wall(20, :right)
    wall(33, :up)
    wall(80, :right) {
      door(1, 78).casement(76, origin: 1, reverse: true)
    }
    wall(383, :down, name: 'bedroom_kitchen') {
      switch('bedroom_switch', 85)
    }
    wall(283, :left, width: 15) {
      window(21, 110).casement(100, origin: 5)
    }
    wall(281, :up, width: 15)
  }

  room('kitchen', anchor: 'bedroom_kitchen.b2') {
    wall(250, :right, width: 15) {
      window(118, 110).casement(100, origin: 5, reverse: true)
    }
    wall(383, :up, name: 'kitchen') {
      door(90, 88).casement(86, outside: true)
      switch('kitchen_switch_1', 185)
    }
    wall(190, :left) {
      switch('kitchen_switch_2', 100)
    }
    wall(60, :down)
    wall(60, :left)
    wall(323, :down)
  }

  room('gas line', anchor: 'bedroom_kitchen.b1') {
    wall(55, :right)
    wall(55, :down)
    wall(55, :left)
    wall(55, :up)
  }
}
