module Plan
  # Casement on this object (ex: double door)
  class Casement
    attr_accessor :origin, :length, :angle, :reverse, :side

    def initialize(origin, length, angle, reverse, side)
      @origin = origin
      @length = length
      @angle = angle
      @reverse = reverse
      @side = side
    end

    def mirror?
      @reverse == @side
    end

    def add_reverse
      @reverse ? Math::PI : 0
    end

    def add_side
      @side ? Math::PI : 0
    end

    def add_origin
      @origin + (@reverse ? @length : 0)
    end
  end

  # Opening object in a wall (ex: Window or Door).
  class Opening
    attr_reader :origin, :length

    def initialize(origin, length)
      @origin = origin
      @length = length

      @casements = []
    end

    def add_center(center)
      @center = center
    end

    def translate(amount)
      @origin += amount
      self
    end

    def casement(length, reverse: false, origin: nil, angle: Math::PI / 2.0, outside: false)
      origin ||= @casements.any? ? @casements.last.origin + @casements.last.length : 0
      @casements << Casement.new(origin, length, angle, reverse, outside)
      self
    end

    def svg_elements(wall)
      class_name = self.class.name.demodulize
      Plan.log.debug("Draw SVG elements for #{class_name} of wall: #{wall}")
      opening_center = wall.ab1.translate(wall.angle, @origin)

      SVGGroup.new("#{class_name}_#{object_id}".to_id).add do |group|
        group.concat(svg_elements_casements(wall, opening_center))
        group.concat(svg_elements_opening(wall, opening_center))
      end
    end

    def svg_elements_casements(wall, opening_center)
      @casements.map { |casement| casement_svg_element(wall.angle, casement, opening_center) }
    end

    def svg_elements_opening(wall, opening_center)
      [
        SVGPolygon.new(svg_elements_vertice(wall)),
        SVGLine.new(opening_center, opening_center.translate(wall.angle, @length))
      ]
    end

    def svg_elements_vertice(wall)
      opening_a1 = wall.vertex_a1.translate(wall.angle, @origin)
      opening_b1 = wall.vertex_b1.translate(wall.angle, @origin)
      opening_a2 = opening_a1.translate(wall.angle, @length)
      opening_b2 = opening_b1.translate(wall.angle, @length)
      [opening_a1, opening_b1, opening_b2, opening_a2]
    end

    def casement_svg_element(angle, casement, opening_anchor)
      position = Plan.position_against(@center, opening_anchor, opening_anchor.translate(angle, casement.length))
      casement_origin = opening_anchor.translate(angle, casement.add_origin)
      base_angle, casement_angle = compute_angles(angle, casement, position)

      [
        SVGPath.new(casement_origin)
               .line_to(casement_origin.translate(base_angle, casement.length))
               .arc(
                 Point.new(casement.length.abs, casement.length.abs),
                 casement_origin.translate(casement_angle, casement.length), 0, 0
               ),
        SVGLine.new(casement_origin, casement_origin.translate(casement_angle, casement.length))
               .css_class('casement_panel')
      ]
    end

    def compute_angles(angle, casement, position)
      [
        angle.rotate_rad(casement.angle * position) + casement.add_side,
        angle + casement.add_reverse
      ].tap do |angles|
        angles.reverse! if casement.mirror? && position.negative? || !casement.mirror? && position.positive?
      end
    end
  end
end
