module Plan
  class SVGFloor
    BUTTON_HEIGHT = 25
    BUTTON_PADDING = 5
    BUTTON_WIDTH = 100

    def self.components(floors)
      button_y = 30

      SVGGroup.new('floors_interaction').add do |group|
        group << SVGText.new('Floors', Point.new(50, 20)).anchor('middle').css_class('component-title')
        floors.each do |floor|
          group << SVGButton.new(
            floor.name,
            floor.name.capitalize,
            0,
            button_y,
            BUTTON_WIDTH,
            BUTTON_HEIGHT
          ).svg_elements.on_click("floors_interaction('#{floor.id}')")
          button_y += BUTTON_HEIGHT + BUTTON_PADDING
        end
      end
    end
  end
end
