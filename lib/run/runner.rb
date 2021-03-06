require 'optparse'
require 'ostruct'
require 'fileutils'

module Plan
  # Run the generation of the SVG file based on the config file
  class Runner
    def initialize(args)
      @options = PlanOptions.parse(args)
      PluginLoader.load_plugins
    end

    def run
      data_loaded = Runner.load_elements(@options.configuration_file, @options.wall_merger, @options.wall_filler)
      elements = data_loaded.elements
      min_vertex, max_vertex = Runner.bounds(elements)
      svg = SVG.new(data_loaded.metadata, Runner.svg_interactions(elements))
      svg.add_contents(Runner.svg_elements(elements, min_vertex))
      svg.add_contents(Runner.svg_document_elements(elements, max_vertex)) if @options.display_area
      Runner.save_plan(svg, @options.output_file, *max_vertex.xy, @options.validation)
      open_result(@options.output_file) if @options.open_result
    end

    def self.load_elements(configuration_file, wall_merger, wall_filler)
      DataLoader.load(configuration_file).tap do |data_loaded|
        data_loaded.elements.each do |element|
          WallMerger.new(element.wall_pool).merge_walls if wall_merger
          WallFiller.new(element.wall_pool).fill_walls if wall_filler
        end
      end
    end

    def self.svg_elements(floors, translation)
      SVGGroup.new('root_panel').add(floors.map(&:svg_elements).flatten).translate(translation)
    end

    def self.save_plan(svg, output_file, width, height, validate)
      FileUtils.mkdir_p(File.dirname(output_file))
      svg.write File.new(output_file, 'w'), width, height, validate
      Plan.log.info('Generation done')
    end

    def self.bounds(floors)
      return [Point::ZERO, Point::ZERO] if floors.empty?

      min_vertex, max_vertex = Plan.bounds(floors.map(&:vertices).flatten)
      min_vertex = (-min_vertex).add(50, 50)

      [min_vertex, max_vertex + min_vertex]
    end

    def self.svg_interactions(floors)
      interactions = SVGInteraction.new
      interactions.add_floor_chooser(floors) if floors.size > 1
      interactions.finalized
    end

    def self.svg_document_elements(floors, max_vertex)
      [
        SVGText.new(
          "Total: #{floors.map(&:area).reduce(0, :+).round(2)} m²",
          Point.new(max_vertex.x / 2, max_vertex.y + 50)
        ).anchor(:middle)
      ]
    end

    def open_result(file)
      require 'launchy'
      Launchy.open("file://#{File.absolute_path(file)}") do |exception|
        Plan.log.error("Attempted to open #{file} and failed because #{exception}")
      end
    end
  end
end
