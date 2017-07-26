module Plan
  # Represent a door placed on a wall (derive from opening)
  class Door < Opening
    def svg_elements(wall)
      super(wall).css_class('door')
    end
  end
end
