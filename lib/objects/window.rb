module Plan
  class Window < Opening
    def svg_elements(wall)
      super(wall).css_class('window')
    end
  end
end
