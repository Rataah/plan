class SlidingDoor < Plan::WallObject
  Door = Struct.new(:coordinates, :origin, :length, :even)
  attr_accessor :length, :width
  amount_translation 0

  # override
  def self.create_from_wall(origin, length, wall)
    super(nil, origin, wall).tap do |opening|
      opening.length = length
      opening.width = wall.width
    end
  end

  def door(length, origin = 0, even = nil)
    even = !(doors.last && doors.last.even || false) if even.nil?
    doors << Door.new(@coordinates.translate(@angle, origin), origin, length, even)
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
      group << Plan::SVGPolygon.new(vertices).css_class('sliding-door')
      group.push(*doors_svg_elements(right_angle))
    end
  end

  private

  def doors
    (@doors ||= [])
  end

  def doors_svg_elements(right_angle)
    door_width = @width / 2.0
    doors.map do |door|
      coordinates = door.coordinates.translate(right_angle, door.even ? 0 : door_width)
      door_vertices = [
        coordinates,
        coordinates.translate(@angle, door.length),
        coordinates.translate(@angle, door.length).translate(right_angle, door_width),
        coordinates.translate(right_angle, door_width)
      ]
      Plan::SVGPolygon.new(door_vertices).css_class('sliding-door-door')
    end
  end
end

class SlidingDoorPlugin < Plan::WallPlugin
  register sliding_door: SlidingDoor
  css 'sliding_door.css'.freeze
end
