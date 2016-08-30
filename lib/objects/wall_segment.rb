module Plan
  # Represent a single point on a wall. Two SegmentIndex are needed to build a WallSegment
  class SegmentIndex
    attr_accessor :side, :index

    def initialize(side, index)
      @side = side
      @index = index
    end

    def a?
      @side == :a
    end

    def b?
      @side == :b
    end

    def other_side
      SegmentIndex.new(a? ? :b : :a, @index)
    end
  end

  # Represent the link between a room and a wall
  class WallSegment
    attr_accessor :wall, :vertex1, :vertex2, :angle

    def initialize(wall, vertex1, vertex2, angle)
      @wall = wall
      @vertex1 = vertex1
      @vertex2 = vertex2
      @angle = angle
    end

    def vertices
      @wall.vertices [@vertex1, @vertex2]
    end

    def centers
      [].tap do |center_points|
        @wall.vertices([@vertex1, @vertex2]).zip @wall.vertices([@vertex1.other_side, @vertex2.other_side]) do |points|
          center_points << Plan.center(points)
        end
      end
    end

    def distance
      segment = vertices
      segment.first.dist segment.last
    end

    def apply_width(ref_point)
      @wall.apply_width(ref_point)
    end

    def svg_elements(ref_point)
      segment_vertices = vertices
      direction = Plan.position_against(ref_point, segment_vertices.first, segment_vertices.last)
      offset_angle = @angle + (90.rad * -direction)

      label_vertices = segment_vertices.map { |vertex| vertex.translate(offset_angle, @wall.width + 10) }
      [
        SVGLine.new(segment_vertices.first, label_vertices.first).stroke('black'),
        SVGLine.new(segment_vertices.last, label_vertices.last).stroke('black'),
        SVGLine.new(*label_vertices).stroke('black'),
        SVGText.new("#{distance.to_i}cm", Plan.center(label_vertices)
          .translate(offset_angle, 15)).rotate(offset_angle).css_class('dimension')
      ]
    end
  end
end
