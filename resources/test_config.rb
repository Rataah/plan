metadata {
  title 'Apartment'
  author 'Rataah'
  version '0.1.0'
}

floor('apartment') {
  room('dining room') {
    wall(368, :right, width: 15) {
      power_outlet('dining_room_power_outlet_1', 220)
    }
    wall(570, :down, width: 15) {
      power_outlet('dining_room_power_outlet_3', 130)

      power_outlet('dining_room_power_outlet_4', 270)
      power_outlet('dining_room_power_outlet_5', 290)

      power_outlet('dining_room_power_outlet_6', 550)
    }
    wall(368, :left, width: 15) {
      window(60, 245).casement(80, origin: 82.5).casement(80, reverse: true)
      power_outlet('dining_room_power_outlet_7', 340)
    }
    wall(570, :up, name: 'dining_room_hall') {
      door(440, 130).casement(41, origin: 2).casement(80, reverse: true)
      switch('dining_room_switch_1', 185)
      power_outlet('dining_room_power_outlet_8', 405)
      switch('dining_room_switch_2', 420)
    }

    ceiling_light('dining_ceiling_light', 180, 280).link('dining_room_switch_1').link('dining_room_switch_2')
  }

  room('hall', anchor: 'dining_room_hall.b2') {
    wall(335, :left, width: 15) {
      switch('hall_switch_1', 100)
      door(117, 102).casement(92, origin: 5, reverse: true)
      power_outlet('hall_power_outlet_1', 230)
    }
    wall(182, :down, name: 'hall_toilets')
    wall(117, :right) {
      switch('hall_switch_2', 95)
    }
    wall(64, :up)
    wall(130, :right) {
      power_outlet('hall_power_outlet_2', 110)
    }
    wall(64, :down) {
      switch('hall_switch_3', 30)
    }
    wall(88, :right) {
      door(1, 86).casement(84, origin: 1, reverse: true, outside: true)
    }
    wall(182, :up, name: 'dining_room_hall2')

    ceiling_light('hall_light', 200, 60)
      .link('hall_switch_1')
      .link('hall_switch_2')
      .link('hall_switch_3')
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

    ceiling_light('toilets_light', 110, 42).link('toilets_switch')
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
      power_outlet('bathroom_power_outlet_1', 30)
    }
    wall(194, :down, width: 15) {
      power_outlet('bathroom_power_outlet_2', 100)
    }
    wall(178, :right, name: 'bathroom_bedroom')
    wall(69, :up)
    wall(20, :right)
    wall(125, :up, name: 'bathroom_hall') {
      door(41, 83).casement(81, origin: 1, outside: true)
    }

    ceiling_light('bathroom_light', 140, 45).link('bathroom_switch')
    ceiling_light('bathroom_light_mirror', 10, 60).link('bathroom_switch')
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
      power_outlet('bedroom_power_outlet_1', 100)
      power_outlet('bedroom_power_outlet_2', 225)
    }
    wall(283, :left, width: 15) {
      window(21, 110).casement(100, origin: 5)
    }
    wall(281, :up, width: 15) {
      power_outlet('bedroom_power_outlet_3', 65)
      power_outlet('bedroom_power_outlet_4', 255)
    }

    ceiling_light('bedroom_light', 141, 240).link('bedroom_switch')
  }

  room('kitchen', anchor: 'bedroom_kitchen.b2') {
    wall(250, :right, width: 15) {
      window(118, 110).casement(100, origin: 5, reverse: true)
    }
    wall(383, :up, name: 'kitchen_dining_room') {
      power_outlet('kitchen_power_outlet_1', 85)
      door(90, 88).casement(86, outside: true)
      switch('kitchen_switch_1', 185)
    }
    wall(190, :left) {
      switch('kitchen_switch_2', 100)
      power_outlet('kitchen_power_outlet_2', 115)
    }
    wall(60, :down)
    wall(60, :left)
    wall(323, :down) {
      power_outlet('kitchen_power_outlet_3', 30)
      power_outlet('kitchen_power_outlet_4', 180)
    }

    ceiling_light('kitchen_light_1', 125, 180).link('kitchen_switch_1').link('kitchen_switch_2')
    ceiling_light('kitchen_light_2', 10, 200).link('kitchen_switch_2')
  }

  room('gas line', anchor: 'bedroom_kitchen.b1') {
    wall(55, :right)
    wall(55, :down)
    wall(55, :left)
    wall(55, :up)
  }
}
