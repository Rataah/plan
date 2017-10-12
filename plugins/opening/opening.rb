class Opening < Plan::WallObject
  attr_accessor :length, :width
  amount_translation 0

  # override
  def self.create_from_wall(origin, length, wall)
    super(nil, origin, wall).tap do |opening|
      opening.length = length
      opening.width = wall.width
    end
  end

  def casement(length, reverse: false, origin: nil, outside: false)
    origin ||= casements.any? ? casements.last.origin + casements.last.length : 0
    casements << Casement.new(@coordinates.translate(@angle, origin), origin, length, reverse, outside)
    self
  end

  def finalize(_, clockwise)
    @clockwise = clockwise
  end

  def custom_svg_elements(_)
    right_angle = @clockwise ? @angle.rotate_rad : @angle.rotate_rad(-Numeric::PI_2)
    Plan::SVGGroup.new(@name.to_id).add do |group|
      vertices = [
        @coordinates,
        @coordinates.translate(@angle, @length),
        @coordinates.translate(@angle, @length).translate(right_angle, @width),
        @coordinates.translate(right_angle, @width)
      ]
      group << Plan::SVGPolygon.new(vertices).css_class('opening-base')
      group.concat(casements.map { |casement| casement.svg_elements(@clockwise, @angle, @width) })
    end
  end

  private

  def casements
    (@casements ||= [])
  end
end

class Casement
  attr_accessor :coordinates, :origin, :length, :reverse, :outside

  def initialize(coordinates, origin, length, reverse, outside)
    @coordinates = coordinates
    @origin = origin
    @length = length
    @reverse = reverse
    @outside = outside
  end

  def svg_elements(clockwise, angle, width)
    @outside = !@outside if clockwise
    @coordinates = @coordinates.translate(angle.rotate_rad(clockwise.to_i * Numeric::PI_2), width / 2.0)

    base_point, final_point = [
      @coordinates,
      @coordinates.translate(angle, @length)
    ].reverse_if @reverse

    casement_coordinates = base_point.translate(
      angle.rotate_rad(@outside.to_i * -Numeric::PI_2), @length
    )

    [
      Plan::SVGPath.new(base_point)
                   .line_to(final_point)
                   .arc(Plan::Point.new(@length, @length).abs,
                        casement_coordinates, 0, @outside ^ @reverse ? 0 : 1)
                   .close_path.css_class('casement')
    ]
  end
end

class Door < Opening; end
class Window < Opening; end

class OpeningPlugin < Plan::WallPlugin
  register door: Door, window: Window
  css 'opening.css'.freeze
end
