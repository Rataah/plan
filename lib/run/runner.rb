require 'optparse'
require 'ostruct'
require 'fileutils'

module Plan
  # Run the generation of the SVG file based on the config file
  class Runner
    def initialize(args)
      @options = OpenStruct.new(wall_merger: true, wall_filler: true, display_area: true)
      option_parser = OptionParser.new do |opts|
        opts.on('-f', '--file FILE', 'Blueprint definition file') do |conf_file|
          @options.configuration_file = conf_file
        end

        opts.on('-o', '--output FILE', 'Output file') do |output_file|
          @options.output_file = output_file
        end

        opts.on('--disable-wall-merger', 'Disable the wall merger step') do
          @options.wall_merger = false
        end

        opts.on('--disable-wall-filler', 'Disable the wall filler step') do
          @options.wall_filler = false
        end

        opts.on('--disable-display-area', 'Disable the display of the total area') do
          @options.display_area = false
        end

        opts.on('-h', '--help', 'Display this screen') do
          puts opts
          exit
        end
      end
      option_parser.parse!(args)

      if @options.configuration_file.nil? || @options.output_file.nil?
        puts 'Missing Argument(s)'
        puts option_parser
        exit
      end
    end

    def run
      rooms = DataLoader.load(@options.configuration_file)

      WallMerger.merge_walls if @options.wall_merger
      WallFiller.fill_walls if @options.wall_filler

      max_vertex = translate_elements(rooms)

      svg = SVG.new
      svg.contents.concat(svg_elements(rooms, max_vertex))

      FileUtils.mkdir_p(File.dirname(@options.output_file))
      svg.write File.new(@options.output_file, 'w'), max_vertex.x + 100, max_vertex.y + 100
      Plan.log.info('Generation done')
    end

    def translate_elements(rooms)
      min_vertex, max_vertex = Plan.bounds(WallPool.all.map(&:vertices).flatten)
      min_vertex = (-min_vertex).add(50, 50)

      rooms.each { |room| room.translate(*min_vertex.xy) }
      WallPool.each { |wall| wall.translate(*min_vertex.xy) }
      max_vertex + min_vertex
    end

    def svg_elements(rooms, max_vertex)
      (rooms.map(&:svg_elements) + WallPool.all.map(&:svg_elements) + svg_document_elements(rooms, max_vertex)).flatten
    end

    def svg_document_elements(rooms, max_vertex)
      return [] unless @options.display_area

      [
        SVGText.new(
          "Total: #{rooms.map(&:area).reduce(0, :+).round(2)} m²",
          Point.new(max_vertex.x / 2, max_vertex.y + 50)
        ).anchor(:middle)
      ]
    end
  end
end
