module Plan
  class SVGInteraction
    attr_reader :components

    def initialize
      @components = []
      set_panel
    end

    def set_panel
      @components << SVGRect.new(0, 0, 120, '100%').css_class('component-panel')
    end

    def add_floor_chooser(floors)
      @components << SVGFloor.components(floors).transform('translate(10)')
    end
  end
end
