module Plan
  # SVG Generation handler
  class SVG
    WIDTH = 1600
    HEIGHT = 900

    attr_accessor :contents, :components, :defs

    def initialize
      @contents = []
      @components = []

      @patterns = []
      @gradients = []
      use_gradient('steel')
    end

    def use_pattern(pattern_name)
      @patterns << pattern_name
    end

    def use_gradient(gradient_name)
      @gradients << gradient_name
    end

    def load(prefix, pattern_name)
      Nokogiri::XML::DocumentFragment.parse(File.read("./resources/#{prefix}/#{pattern_name}.xml")).to_xml
    end

    def write(output)
      Plan.log.info("Generating SVG file #{File.expand_path(output.path)}")
      svg = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.doc.create_internal_subset('svg', '-//W3C//DTD SVG 1.1//EN',
                                       'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd')
        xml.svg(width: '100%', height: '100%', xmlns: 'http://www.w3.org/2000/svg') do
          css = File.read('./resources/css/plan.css')
          xml.style(css, type: 'text/css')
          script = File.read('./resources/javascript/plan.js')
          xml.script(script, type: 'text/ecmascript')

          xml.defs do |defs|
            @patterns.each { |pattern_name| defs << load('patterns', pattern_name) }
            @gradients.each { |gradient_name| defs << load('gradients', gradient_name) }
          end

          SVGGroup.new('root_component').add do |root_component|
            root_component.concat(@components)
          end.xml_element(xml)
          SVGGroup.new('root_content').add do |root_content|
            root_content.concat(@contents)
          end.transform('translate(140)').xml_element(xml)
        end
      end

      validate(svg.doc)
      output.write(svg.to_xml.gsub(%(<?xml version="1.0"?>), %(<?xml version="1.0" standalone="no"?>)))
      Plan.log.info("File size: #{File.size(output.path).to_file_size}")
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
