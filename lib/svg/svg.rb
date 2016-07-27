module Plan
  class SVG
    WIDTH = 1600
    HEIGHT = 900

    attr_accessor :contents, :defs

    def initialize
      @contents = []
      @defs = []
    end

    def load_pattern(pattern_name)
      Nokogiri::XML::DocumentFragment.parse(File.read("./resources/patterns/#{pattern_name}.xml")).to_xml
    end

    def write(output)
      svg = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|

        xml.doc.create_internal_subset('svg', '-//W3C//DTD SVG 1.1//EN', 'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd')
        xml.svg(width: WIDTH, height: HEIGHT, version: '1.1', xmlns: 'http://www.w3.org/2000/svg') do
          css = File.read('./resources/css/plan.css')
          xml.style(css)

          xml.defs do |defs|
            defs << load_pattern('tiles')
            defs << load_pattern('blueprint')
            defs << load_pattern('carbon')
          end

          @contents.each do |content|
            content.xml_element(xml)
          end
        end
      end
      output.write(svg.to_xml.gsub(%Q(<?xml version="1.0"?>), %Q(<?xml version="1.0" standalone="no"?>)))
    end
  end
end