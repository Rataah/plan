class OpeningPlugin < Plan::WallPlugin
  def self.register
    { door: Door, window: Window }
  end

  def self.svg_include
    nil
  end
end

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
    clockwise_angle = @clockwise ? @angle.rotate_rad(Math::PI) : @angle
    right_angle = @clockwise ? @angle.rotate_rad : @angle.rotate_rad(-Numeric::PI_2)
    Plan::SVGGroup.new(@name.to_id).add do |group|
      vertices = [
        @coordinates,
        @coordinates.translate(@angle, @length),
        @coordinates.translate(@angle, @length).translate(right_angle, @width),
        @coordinates.translate(right_angle, @width)
      ]
      group << Plan::SVGPolygon.new(vertices).fill('none')
      group.concat(@casements.map { |casement| casement.svg_elements(@clockwise, clockwise_angle) })
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

  def svg_elements(_, angle)
    base_point, final_point = [@coordinates, @coordinates.translate(angle, @length)].reverse_if(@reverse)
    casement_coordinates = base_point.translate(@outside.to_i * Numeric::PI_2, @length)
    [
      Plan::SVGPath.new(base_point)
                   .line_to(final_point)
                   .arc(Plan::Point.new(@length, @length).abs, casement_coordinates, 0, 0)
                   .close_path
    ]
  end
end

class Door < Opening; end
class Window < Opening; end
