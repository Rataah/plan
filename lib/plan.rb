module Plan
  ROOT = File.expand_path('..', File.dirname(__FILE__)).freeze
end

require 'nokogiri'
require 'logger'

require 'version'

# tools
require 'tools/tools'
require 'tools/point'
require 'tools/array'
require 'tools/string'
require 'tools/numeric'
require 'tools/bool'
require 'tools/logger'
require 'tools/hash'
require 'tools/geometry'

# plugins
require 'plugins/plugin_loader'
require 'plugins/room_plugin'
require 'plugins/wall_plugin'

# svg
require 'svg/svg'
require 'svg/svg_tools'
require 'svg/elements/svg_arguments'
require 'svg/elements/svg_element'
require 'svg/elements/svg_group'
require 'svg/elements/svg_line'
require 'svg/elements/svg_text'
require 'svg/elements/svg_polygon'
require 'svg/elements/svg_path'
require 'svg/elements/svg_rect'
require 'svg/elements/svg_title'
require 'svg/elements/svg_metadata'
require 'svg/elements/svg_use'

require 'svg/ui/svg_button'
require 'svg/ui/svg_floor'
require 'svg/ui/svg_interaction'

# elements
require 'objects/helpers/wall_helper'
require 'objects/factories/floor_factory'
require 'objects/factories/room_factory'
require 'objects/factories/wall_factory'
require 'objects/factories/metadata_factory'
require 'objects/wall_segment'
require 'objects/floor'
require 'objects/room'
require 'objects/wall'
require 'objects/opening'
require 'objects/window'
require 'objects/door'

# symbols
require 'objects/symbols/wall_object'
require 'objects/symbols/room_object'

# transformations
require 'run/transformations/wall_merger'
require 'run/transformations/wall_filler'

# parser
require 'run/parsers/data_loader'
require 'run/parsers/data_loaded'
require 'run/parsers/metadata'
require 'run/parsers/ruby_data_loader'

# main
require 'run/plan_options'
require 'run/runner'
require 'run/wall_pool'
require 'run/symbol_pool'
