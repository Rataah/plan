module Plan
  class Door < Opening
    def svg_elements(wall)
      super(wall).css_class('door')
    end
  end
end
