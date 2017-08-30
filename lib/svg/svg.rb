module Plan
  # SVG Generation handler
  class SVG
    WIDTH = 1600
    HEIGHT = 900

    attr_reader :contents, :components, :symbols, :defs

    def initialize(metadata, components)
      @metadata = metadata
      @contents = []
      @components = components

      @patterns = []
      use_pattern('stripes')

      @gradients = []
      use_gradient('steel')

      @symbols = []
      use_symbol('switch')
      use_symbol('ceiling_light')
      use_symbol('power_outlet')
    end

    def add_contents(contents)
      @contents.push(contents)
    end

    def use_pattern(pattern_name)
      @patterns << pattern_name
    end

    def use_gradient(gradient_name)
      @gradients << gradient_name
    end

    def use_symbol(symbol_name)
      @symbols << symbol_name
    end

    def write(output, width, height)
      Plan.log.info('Generating SVG file')
      svg = Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |xml| build_svg xml, width, height }

      SVG.validate(svg.doc)
      output.write(svg.to_xml.gsub(%(<?xml version="1.0"?>), %(<?xml version="1.0" standalone="no"?>)))
      Plan.log.info("File size: #{File.size(output.path).to_file_size}")
    end

    def build_svg(xml, _, _)
      xml.svg(
        width: '297mm',
        height: '210mm',
        xmlns: 'http://www.w3.org/2000/svg'
      ) do
        xml.doc.create_internal_subset('svg', '-//W3C//DTD SVG 1.1//EN',
                                       'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd')
        insert_metadata xml
        insert_css_scripts xml
        insert_shared xml

        insert_components xml
        insert_content xml
      end
    end

    def insert_metadata(xml)
      @metadata.svg_elements.each { |element| element.xml_element(xml) }
    end

    def insert_css_scripts(xml)
      xml.style(File.read('./resources/css/plan.css'), type: 'text/css')
      xml.script(File.read('./resources/javascript/plan.js'), type: 'text/ecmascript')
    end

    def insert_shared(xml)
      xml.defs do |defs|
        @patterns.each { |pattern_name| defs << SVG.load('patterns', pattern_name) }
        @gradients.each { |gradient_name| defs << SVG.load('gradients', gradient_name) }
        @symbols.each { |symbol_name| defs << SVG.load('symbols', symbol_name) }
      end
    end

    def insert_components(xml)
      SVGGroup.new('root_component').add do |root_component|
        root_component.concat(@components)
      end.xml_element(xml)
    end

    def insert_content(xml)
      SVGGroup.new('root_content').add do |root_content|
        root_content.concat(@contents)
      end.xml_element(xml)
    end

    def self.validate(doc)
      Dir.chdir('./resources/xsd/') do
        Plan.log.debug('Validating XML')
        xsd = Nokogiri::XML::Schema(File.read('schema.xsd'))
        xsd.validate(doc).each do |error|
          Plan.log.error(error.message)
        end
      end
    end

    def self.load(prefix, pattern_name)
      Nokogiri::XML::DocumentFragment.parse(File.read("./resources/#{prefix}/#{pattern_name}.xml")).to_xml
    end
  end
end
