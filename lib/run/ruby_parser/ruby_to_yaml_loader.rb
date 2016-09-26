module Plan
  # Load and parse Ruby config file
  class RubyToYamlLoader
    def self.load_data_from_file(filename, yaml_filename)
      parse(File.read(filename, encoding: 'BOM|UTF-8', mode: 'rb'), filename, yaml_filename)
    end

    def self.parse(content, filename, yaml_filename)
      data_parser = DataParserYaml.new
      data_parser.instance_eval(content, filename)
      data_parser.finalize yaml_filename
    end

    class DataParserYaml
      def initialize
        @hash = { rooms: [] }
      end

      def room(name, x = nil, y = nil, anchor: nil, &block)
        @hash_room = { name: name }
        @hash_room[:coordinates] = [x, y] if x && y
        @hash_room[:anchor] = anchor if anchor
        @hash_room[:walls] = []

        instance_eval(&block)

        @hash[:rooms] << @hash_room
      end

      def wall(length, direction, width: nil, name: nil, &block)
        @hash_wall = { length: length, direction: direction }
        @hash_wall[:width] = width if width
        @hash_wall[:name] = name if name

        instance_eval(&block) if block_given?

        @hash_room[:walls] << @hash_wall
      end

      def window(origin, length)
        @hash_subwall = { origin: origin, length: length, leaves: [] }
        (@hash_wall[:windows] ||= []) << @hash_subwall
        self
      end

      def door(origin, length)
        @hash_subwall = { origin: origin, length: length, leaves: [] }
        (@hash_wall[:doors] ||= []) << @hash_subwall
        self
      end

      def leave(length, reverse: false, origin: nil, angle: nil, outside: false)
        hash_leave = { length: length }
        hash_leave[:reverse] = true if reverse
        hash_leave[:outside] = true if outside
        hash_leave[:origin] = origin if origin
        hash_leave[:angle] = angle if angle
        @hash_subwall[:leaves] << hash_leave
        self
      end

      def finalize(yaml_filename)
        require 'yaml'
        File.open(yaml_filename, 'w') do |file|
          file.write(Plan.stringify(@hash).to_yaml)
        end
      end
    end
  end
end
