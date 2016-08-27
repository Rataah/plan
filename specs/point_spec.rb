require 'plan'

# Spec file for Point class
module Plan
  describe :point do
    let(:x) { 1 }
    let(:y) { 0.5 }

    subject(:point) { Point.new(x, y) }

    it 'initializes a point with x and y values' do
      expect(point.x).to eq x
      expect(point.y).to eq y
    end

    describe :operations do
      it 'adds new x and y to a point' do
        point.add!(2, 0.3)
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

    describe :on_segment do
      let(:point_a) { Point.new(0, 0) }
      let(:point_b) { Point.new(10, 10) }

      it 'returns true if the point is on the segment' do
        expect(Point.new(5, 5).on_segment(point_a, point_b)).to be true
        expect(Point.new(0, 0).on_segment(point_a, point_b)).to be true
        expect(Point.new(10, 10).on_segment(point_a, point_b)).to be true
      end

      it 'returns false if the point is not on the segment' do
        expect(Point.new(30, -50).on_segment(point_a, point_b)).to be false
        expect(Point.new(-1, -1).on_segment(point_a, point_b)).to be false
        expect(Point.new(11, 11).on_segment(point_a, point_b)).to be false
      end
    end
  end
end
