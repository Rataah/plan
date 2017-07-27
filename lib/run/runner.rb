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
      elements = Runner.load_elements(@options.configuration_file, @options.wall_merger, @options.wall_filler)
      max_vertex = Runner.translate_elements(elements)
      svg = SVG.new(
        @options.display_area ? Runner.svg_elements(elements, max_vertex) : [], 
        Runner.svg_interactions(elements)
      )
      Runner.save_plan(svg, @options.output_file)
    end

    def self.load_elements(configuration_file, wall_merger, wall_filler)
      DataLoader.load(configuration_file).tap do |floors|
        floors.each do |floor|
          WallMerger.new(floor.wall_pool).merge_walls if wall_merger
          WallFiller.new(floor.wall_pool).fill_walls if wall_filler
        end
      end
    end

    def self.svg_elements(floors, max_vertex)
      (
        floors.map(&:svg_elements) + Runner.svg_document_elements(floors, max_vertex)
      ).flatten
    end

    def self.save_plan(svg, output_file)
      FileUtils.mkdir_p(File.dirname(output_file))
      svg.write File.new(output_file, 'w')
      Plan.log.info('Generation done')
    end

    def self.translate_elements(floors)
      min_vertex, max_vertex = Plan.bounds(floors.map(&:vertices).flatten)
      min_vertex = (-min_vertex).add(50, 50)

      floors.each { |floor| floor.translate(*min_vertex.xy) }

      max_vertex + min_vertex
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
  end
end
