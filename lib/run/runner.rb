require 'optparse'
require 'ostruct'
require 'fileutils'

module Plan
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

        opts.on('-h', '--help', 'Display this screen') do
          puts opts
          exit
        end
      end.parse!(args)
    end

    def run
      rooms = case File.extname(@options.configuration_file)
                   when '.yml', '.yaml'
                     YamlDataLoader.load_data_from_file(@options.configuration_file)
                   else
                     RubyDataLoader.load_data_from_file(@options.configuration_file)
                 end
      Plan.merge_walls

      min_vertex, max_vertex = Plan.bounds(WallPool.all.map(&:vertices).flatten)

      rooms.each { |room| room.translate(-min_vertex.x + 50, -min_vertex.y + 50) }
      WallPool.each { |wall| wall.translate(-min_vertex.x + 50, -min_vertex.y + 50) }
      svg = SVG.new

      rooms.each { |room| room.svg_elements.each { |line| svg.contents << line } }
      WallPool.each { |wall| wall.svg_elements.each { |line| svg.contents << line } }

      svg.contents << SVGText.new("Total: #{rooms.map(&:area).reduce(0, :+)} m²", max_vertex.x + 50, max_vertex.y + 150)

      FileUtils.mkdir_p(File.dirname(@options.output_file))
      svg.write File.new(@options.output_file, 'w')
    end
  end
end