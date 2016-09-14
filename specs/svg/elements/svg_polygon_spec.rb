require 'plan'

module Plan
  describe SVGPolygon do
    let(:points) { [Point.new(1, 1), Point.new(2, 2)] }

    it 'initialize the polygon' do
      polygon = SVGPolygon.new(points)
      expect(polygon.args['points']).to eq SVGArg.new(points, true)
    end
  end
end
