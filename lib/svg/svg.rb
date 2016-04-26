module Plan
  class SVG
    attr_accessor :contents, :defs

    def initialize(scale)
      @scale = scale
      @contents = []
      @defs = []
    end

    def scale_content
      @contents.each do |content|
        content.scale
      end
    end

    def write(output)
      output.write(%q(<?xml version="1.0" standalone="no"?>
        <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
        <svg width="1000" height="1000" version="1.1" xmlns="http://www.w3.org/2000/svg">))

      output.write('<defs>')
      output.write(@defs.map(&:write).join("\n"))
      output.write('</defs>')
      output.write(@contents.map { |c| c.xml_element(@scale) }.join("\n"))
      output.write('</svg>')
    end
  end
end