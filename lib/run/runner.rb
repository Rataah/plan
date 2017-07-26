require 'optparse'
require 'ostruct'
require 'fileutils'

module Plan
  # Run the generation of the SVG file based on the config file
  class Runner
    def initialize(args)
      @options = PlanOptions.parse(args)
    end

    def run
      floors = DataLoader.load(@options.configuration_file)
      floors.each do |floor|
        WallMerger.new(floor.wall_pool).merge_walls if @options.wall_merger
        WallFiller.new(floor.wall_pool).fill_walls if @options.wall_filler
      end

      max_vertex = translate_elements(floors)

      svg = SVG.new
      svg.components.concat svg_interactions(floors)
      svg.contents.concat svg_elements(floors, max_vertex)

      FileUtils.mkdir_p(File.dirname(@options.output_file))
      svg.write File.new(@options.output_file, 'w')
      Plan.log.info('Generation done')
    end

    def translate_elements(floors)
      min_vertex, max_vertex = Plan.bounds(floors.map { |floor| floor.wall_pool.all.map(&:vertices) }.flatten)
      min_vertex = (-min_vertex).add(50, 50)

      floors.each do |floor|
        floor.translate(*min_vertex.xy)
        floor.wall_pool.each { |wall| wall.translate(*min_vertex.xy) }
      end

      max_vertex + min_vertex
    end

    def svg_interactions(floors)
      interactions = SVGInteraction.new
      interactions.add_floor_chooser(floors) if floors.size > 1
      interactions.finalized
    end

    def svg_elements(floors, max_vertex)
      (floors.map(&:svg_elements) + svg_document_elements(floors, max_vertex)).flatten
    end

    def svg_document_elements(floors, max_vertex)
      return [] unless @options.display_area

      [
        SVGText.new(
          "Total: #{floors.map(&:area).reduce(0, :+).round(2)} m²",
          Point.new(max_vertex.x / 2, max_vertex.y + 50)
        ).anchor(:middle)
      ]
    end
  end
end
