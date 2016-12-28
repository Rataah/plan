require 'nokogiri'
require 'logger'

# tools
require 'tools/tools'
require 'tools/point'
require 'tools/geometry'
require 'tools/array'
require 'tools/string'
require 'tools/numeric'
require 'tools/logger'
require 'tools/hash'

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

# elements
require 'objects/helpers/wall_helper'
require 'objects/factories/room_factory'
require 'objects/factories/wall_factory'
require 'objects/wall_segment'
require 'objects/room'
require 'objects/wall'
require 'objects/opening'
require 'objects/window'
require 'objects/door'

# transformations
require 'run/transformations/wall_merger'
require 'run/transformations/wall_filler'

# parser
require 'run/parsers/data_loader'
require 'run/parsers/ruby_parser/ruby_data_loader'
require 'run/parsers/yaml_parser/yaml_data_loader'
require 'run/parsers/yaml_parser/yaml_room_factory'
require 'run/parsers/yaml_parser/yaml_wall_factory'
require 'run/parsers/xml_parser/xml_data_loader'
require 'run/parsers/xml_parser/xml_room_factory'
require 'run/parsers/xml_parser/xml_wall_factory'

# main
require 'run/runner'
require 'run/wall_pool'
