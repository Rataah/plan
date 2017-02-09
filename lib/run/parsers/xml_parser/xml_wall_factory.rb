module Plan
  class XMLWallFactory
    CASEMENT_ATTRIBUTES = {
      reverse: ->(value) { value.to_s == 'true' ? true : false },
      origin: ->(value) { value.to_f },
      angle: ->(value) { value.to_f },
      outside: ->(value) { value.to_s == 'true' ? true : false }
    }.freeze

    def self.parse_wall(wall_pool, wall_name, last_point, wall_node)
      width, direction = setup_default(wall_node)

      WallFactory.create(wall_pool, wall_name, last_point, wall_node['length'].to_f, direction, width) do
        XMLWallFactory.parse_openings(self, 'window', wall_node.css('window'))
        XMLWallFactory.parse_openings(self, 'door', wall_node.css('door'))
      end
    end

    def self.parse_openings(wall_factory, method, openings)
      openings.each do |opening_node|
        opening = wall_factory.send(method, opening_node['origin'].to_f, opening_node['length'].to_f)
        opening_node.css('casement').each do |casement_node|
          opening.casement(casement_node['length'].to_f, casement_attributes(casement_node.attributes))
        end
      end
    end

    def self.casement_attributes(attributes)
      attributes
        .keep_if { |key, attr| CASEMENT_ATTRIBUTES.include?(key.to_sym) && !attr.nil? }
        .map { |key, attr| [key.to_sym, CASEMENT_ATTRIBUTES[key.to_sym].call(attr.value)] }
        .to_h
    end

    def self.setup_default(wall_node)
      width = (wall_node['width'] || DEFAULT_WALL_WIDTH).to_f
      direction = wall_node['direction'].numeric? ? wall_node['direction'].to_f : wall_node['direction'].to_sym
      [width, direction]
    end
  end
end
