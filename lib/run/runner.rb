require 'optparse'
require 'ostruct'
require 'fileutils'

module Plan
  # Run the generation of the SVG file based on the config file
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

        opts.on('--ruby-to-yaml FILE', 'Translate Ruby blueprint to this YAML file') do |to_yaml_file|
          @options.ruby_to_yaml = to_yaml_file
        end

        opts.on('-h', '--help', 'Display this screen') do
          puts opts
          exit
        end
      end.parse!(args)
    end

    def run
      rooms = eval_configuration_file

      WallMerger.new.merge_walls

      max_vertex = translate_elements(rooms)

      svg = SVG.new
      svg.contents.push(*svg_elements(rooms, max_vertex))

      FileUtils.mkdir_p(File.dirname(@options.output_file))
      svg.write File.new(@options.output_file, 'w'), max_vertex.x + 100, max_vertex.y + 100
      Plan.log.info('Generation done')
    end

    def eval_configuration_file
      Plan.log.info("Loading configuration from #{@options.configuration_file}")
      case File.extname(@options.configuration_file)
      when '.yml', '.yaml'
        YamlDataLoader.load_data_from_file(@options.configuration_file)
      else
        if @options.ruby_to_yaml
          RubyToYamlLoader.load_data_from_file(@options.configuration_file, @options.ruby_to_yaml)
          exit
        else
          RubyDataLoader.load_data_from_file(@options.configuration_file)
        end
      end
    end

    def translate_elements(rooms)
      min_vertex, max_vertex = Plan.bounds(WallPool.all.map(&:vertices).flatten)
      min_vertex = (-min_vertex).add(50, 50)

      rooms.each { |room| room.translate(*min_vertex.xy) }
      WallPool.each { |wall| wall.translate(*min_vertex.xy) }
      max_vertex += min_vertex
    end

    def svg_elements(rooms, max_vertex)
      (rooms.map(&:svg_elements) + WallPool.all.map(&:svg_elements) + svg_document_elements(rooms, max_vertex)).flatten
    end

    def svg_document_elements(rooms, max_vertex)
      [
        SVGText.new(
          "Total: #{rooms.map(&:area).reduce(0, :+).round(2)} m²",
          Point.new(max_vertex.x / 2, max_vertex.y + 50)
        ).anchor(:middle)
      ]
    end
  end
end
