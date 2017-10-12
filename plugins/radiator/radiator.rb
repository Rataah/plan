class Radiator < Plan::WallObject
  RADIATOR_WIDTH = 16

  attr_accessor :length

  # override
  def self.create_from_wall(origin, length, wall)
    super(nil, origin, wall).tap do |radiator|
      radiator.length = length
    end
  end

  def finalize(_, clockwise)
    @clockwise = clockwise
    @coordinates = @coordinates.translate(
      @clockwise ? @angle.rotate_rad(-Numeric::PI_2) : @angle.rotate_rad,
      RADIATOR_WIDTH
    )
  end

  def custom_svg_elements(_)
    right_angle = @clockwise ? @angle.rotate_rad : @angle.rotate_rad(-Numeric::PI_2)
    Plan::SVGGroup.new(@name.to_id).add do |group|
      vertices = [
        @coordinates,
        @coordinates.translate(@angle, @length),
        @coordinates.translate(@angle, @length).translate(right_angle, RADIATOR_WIDTH),
        @coordinates.translate(right_angle, RADIATOR_WIDTH)
      ]
      group << Plan::SVGPolygon.new(vertices).css_class('radiator')
    end
  end
end

class RadiatorPlugin < Plan::WallPlugin
  register radiator: Radiator
  css 'radiator.css'
end