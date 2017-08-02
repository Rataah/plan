floor('house') do
  room('Sejour', 0, 0) do
    wall(540, :up, width: 12)
    wall(365, :left, width: 5, name: 'sejour_cuisine')
    wall(85, :down, width: 5)
    wall(140, :left, width: 5)
    wall(70, :down, width: 5)
    wall(180, :left, width: 5)
    wall(385, :down, width: 5, name: 'sejour_chambre_5')
    wall(685, :right, width: 12)
  end

  room('Chambre 5', anchor: 'sejour_chambre_5.b1') do
    wall(260, :left, width: 5)
    wall(385, :down, width: 5, name: 'chambre_5_chambre_2')
    wall(260, :right, width: 12)
    wall(385, :up, width: 5)
  end

  room('Chambre 2', anchor: 'chambre_5_chambre_2.b2') do
    wall(295, :left, width: 12)
    wall(380, :up, width: 12)
    wall(115, :right, width: 5)
    wall(60, :up, width: 5)
    wall(180, :right, width: 5, name: 'chambre_2_chambre_1')
    wall(440, :down, width: 5)
  end

  room('Chambre 1', anchor: 'chambre_2_chambre_1.b1') do
    wall(180, :right, width: 5)
    wall(360, :up, width: 5, name: 'chambre_1_chambre_4')
    wall(295, :left, width: 12)
    wall(420, :down, width: 12)
    wall(110, :right, width: 5)
    wall(60, :up, width: 5)
  end

  room('Chambre 4', anchor: 'chambre_1_chambre_4.b2') do
    wall(350, :right, width: 12)
    wall(260, :down, width: 5, name: 'chambre_4_salle_de_bains')
    wall(350, :left, width: 5, name: 'chambre_4_escalier')
    wall(260, :up, width: 5)
  end

  room('Escalier', anchor: 'chambre_4_escalier.b1') do
    wall(255, :left, width: 5)
    wall(80, :down, width: 5)
    wall(255, :right, width: 5)
    wall(80, :up, width: 5)
  end

  room('Salle de bains', anchor: 'chambre_4_salle_de_bains.b1') do
    wall(225, :right, width: 12)
    wall(260, :down, width: 5)
    wall(225, :left, width: 5, name: 'salle_de_bains_wc')
    wall(260, :up, width: 5)
  end

  room('WC', anchor: 'salle_de_bains_wc.b1') do
    wall(135, :left, width: 5)
    wall(80, :down, width: 5, name: 'wc_couloir')
    wall(135, :right, width: 5)
    wall(80, :up, width: 5)
  end

  room('Cuisine', anchor: 'sejour_cuisine.b1') do
    wall(365, :left, width: 5)
    wall(260, :up, width: 5)
    wall(365, :right, width: 12)
    wall(260, :down, width: 12)
  end

  room('Couloir', anchor: 'wc_couloir.b1') do
    wall(150, :down, width: 5)
    wall(440, :left, width: 5)
    wall(150, :up, width: 5)
    wall(90, :right, width: 5)
    wall(85, :down, width: 5)
    wall(265, :right, width: 5)
    wall(85, :up, width: 5)
    wall(85, :right, width: 5)
  end
end