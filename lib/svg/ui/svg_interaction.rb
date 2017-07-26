module Plan
  class SVGInteraction
    attr_reader :components

    def initialize
      @components = []
    end

    def set_panel
      @components.insert(0, SVGRect.new(0, 0, 120, '100%').css_class('component-panel'))
    end

    def add_floor_chooser(floors)
      @components << SVGFloor.components(floors).transform('translate(10)')
    end

    def finalized
      set_panel if @components.any?
      @components
    end
  end
end
