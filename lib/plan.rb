require 'nokogiri'
require 'logger'

require 'version'

# tools
require 'tools/tools'
require 'tools/point'
require 'tools/array'
require 'tools/string'
require 'tools/numeric'
require 'tools/logger'
require 'tools/hash'
require 'tools/geometry'

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
require 'objects/symbols/wall_symbol'
require 'objects/symbols/switch'
require 'objects/symbols/ceiling_light'
require 'objects/symbols/power_outlet'

# transformations
require 'run/transformations/wall_merger'
require 'run/transformations/wall_filler'

# parser
require 'run/parsers/data_loader'
require 'run/parsers/data_loaded'
require 'run/parsers/metadata'
require 'run/parsers/ruby_parser/ruby_data_loader'
require 'run/parsers/yaml_parser/yaml_data_loader'
require 'run/parsers/yaml_parser/yaml_floor_factory'
require 'run/parsers/yaml_parser/yaml_room_factory'
require 'run/parsers/yaml_parser/yaml_wall_factory'
require 'run/parsers/xml_parser/xml_data_loader'
require 'run/parsers/xml_parser/xml_floor_factory'
require 'run/parsers/xml_parser/xml_room_factory'
require 'run/parsers/xml_parser/xml_wall_factory'

# main
require 'run/plan_options'
require 'run/runner'
require 'run/wall_pool'
require 'run/symbol_pool'
