require 'optparse'
require 'ostruct'
require 'fileutils'

module Plan
  logger = Logger.new(STDOUT)

  class Runner

    def initialize(args)
      @options = OpenStruct.new
      OptionParser.new do |opts|
        opts.on('-f', '--file FILE', 'Blueprint definition file') do |conf_file|
          @options.configuration_file = conf_file
        end

        opts.on('-o', '--output FILE', 'Output file') do |output_file|
          @options.output_file = output_file
        end
      end.parse!(args)
    end

    def run
      elements = DataLoader.load_data_from_file(@options.configuration_file)

      min_vertex, max_vertex = Plan.bounds(elements.map(&:vertices).flatten)

      elements.each { |element| element.translate(-min_vertex.x + 50, -min_vertex.y + 50) }
      svg = SVG.new

      elements.each {|element| element.svg_elements.each {|line| svg.contents << line}}
      svg.contents << SVGText.new("Total: #{elements.map(&:area).reduce(0,:+)} m²", max_vertex.x + 50, max_vertex.y + 150)

      FileUtils.mkdir_p(File.dirname(@options.output_file))
      svg.write File.new(@options.output_file, 'w')
    end
  end
end