module Plan
  # SVG Generation handler
  class SVG
    WIDTH = 1600
    HEIGHT = 900

    attr_accessor :contents, :defs

    def initialize
      @contents = []
      @defs = []
    end

    def use_pattern(pattern_name)
      (@patterns ||= []) << pattern_name
    end

    def load_pattern(pattern_name)
      Nokogiri::XML::DocumentFragment.parse(File.read("./resources/patterns/#{pattern_name}.xml")).to_xml
    end

    def write(output, width = WIDTH, height = HEIGHT)
      Plan.log.info("Generating SVG file #{output.path}")
      svg = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.doc.create_internal_subset('svg', '-//W3C//DTD SVG 1.1//EN',
                                       'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd')
        xml.svg(width: width, height: height, xmlns: 'http://www.w3.org/2000/svg') do
          css = File.read('./resources/css/plan.css')
          xml.style(css, type: 'text/css')

          xml.defs do |defs|
            @patterns.each { |pattern_name| defs << load_pattern(pattern_name) }
          end unless @patterns.nil?

          @contents.each do |content|
            content.xml_element(xml)
          end
        end
      end
      validate(svg.doc)
      output.write(svg.to_xml.gsub(%(<?xml version="1.0"?>), %(<?xml version="1.0" standalone="no"?>)))
    end

    def validate(doc)
      Dir.chdir('./resources/xsd/') do
        Plan.log.debug('Validating XML')
        xsd = Nokogiri::XML::Schema(File.read('SVG.xsd'))
        xsd.validate(doc).each do |error|
          Plan.log.error(error.message)
        end
      end
    end
  end
end
