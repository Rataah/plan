module Plan
  # Represent a window placed on a wall (derive from opening)
  class Window < Opening
    def svg_elements(wall)
      super(wall).css_class('window')
    end
  end
end
