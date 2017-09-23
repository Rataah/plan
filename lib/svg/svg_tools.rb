module Plan
  class SVGTools
    def self.dimensions(id, vertices, wall_vertices, wall_angle, offset)
      angle = wall_angle + Plan.normal_angle(
        wall_vertices,
        vertices.first,
        vertices.last,
        wall_angle,
        true
      )

      label_vertices = vertices.map { |vertex| vertex.translate(angle, offset) }
      SVGGroup.new(id).add([].tap do |group|
        vertices.each_with_index do |vertex, index|
          group << SVGLine.new(vertex, label_vertices[index]).stroke('black')
        end
        group << SVGLine.new(label_vertices.first, label_vertices.last).stroke('black')
        label_vertices.each_cons(2) do |vertex1, vertex2|
          group << SVGText.new("#{vertex1.dist(vertex2).to_i}cm", Plan.center(vertex1, vertex2)
            .translate(angle, 15)).anchor(:middle).rotate(angle).css_class('dimension')
        end
      end)
    end
  end
end
