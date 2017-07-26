module Plan
  class SVGButton
    def initialize(id, text_content, x, y, width, height)
      @id = id
      @text_content = text_content
      @button_x = x
      @button_y = y
      @button_width = width
      @button_height = height
    end

    def svg_elements
      SVGGroup.new("button_#{@id}".to_id).add do |svg_group|
        svg_group << SVGRect.new(@button_x, @button_y, @button_width, @button_height).css_class('button')
        svg_group << SVGText.new(
          @text_content,
          Point.new(@button_x + @button_width / 2.0, @button_y + @button_height - 6)
        ).css_class('button-content').anchor('middle')
      end
    end
  end
end
