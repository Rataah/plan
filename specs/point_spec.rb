require 'plan'

module Plan

  describe :point do
    let(:x) { 1 }
    let(:y) { 0.5 }

    subject(:point) { Point.new(x, y)}

    it 'initializes a point with x and y values' do
      expect(point.x).to eq x
      expect(point.y).to eq y
    end

    describe :operations do
      it 'adds new x and y to a point' do
        point.add(2, 0.3)
        expect(point.x).to eq 3
        expect(point.y).to eq 0.8
      end

      describe :dist do
        it '' do
          expect(point.dist(Point.new(0, 0))).to eq Math.hypot(1, 0.5)
          expect(point.dist(Point.new(1, 0))).to eq Math.hypot(0, 0.5)
          expect(point.dist(Point.new(-10, 0))).to eq Math.hypot(11, 0.5)
          expect(point.dist(Point.new(0, 1))).to eq Math.hypot(1, -0.5)
          expect(point.dist(Point.new(0, -10))).to eq Math.hypot(1, 10.5)
        end
      end
    end
  end
end