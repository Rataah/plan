module Plan
  class SVGTools
    def self.dimensions(id, vertices, reference_point, offset)
      angle = Math.atan2(*(vertices.first - vertices.last).xy)

      direction = Plan.position_against(reference_point, vertices.first, vertices.last)
      offset_angle = angle + (90.rad * -direction)

      label_vertices = vertices.map { |vertex| vertex.translate(offset_angle, offset) }
      SVGGroup.new(id).add([].tap do |group|
        vertices.each_with_index do |vertex, index|
          group << SVGLine.new(vertex, label_vertices[index]).stroke('black')
        end
        group << SVGLine.new(label_vertices.first, label_vertices.last).stroke('black')
        label_vertices.each_cons(2) do |vertex_1, vertex_2|
          group << SVGText.new("#{vertex_1.dist(vertex_2).to_i}cm", Plan.center([vertex_1, vertex_2])
            .translate(offset_angle, 15)).anchor(:middle).rotate(offset_angle).css_class('dimension')
        end
      end)
    end
  end
end
