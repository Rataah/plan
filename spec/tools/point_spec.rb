require 'plan'

# Spec file for Point class
module Plan
  describe Point do
    let(:x) { 1 }
    let(:y) { 0.5 }

    subject(:point) { Point.new(x, y) }

    it 'initializes a point with x and y values' do
      expect(point.x).to eq x
      expect(point.y).to eq y
    end

    describe :operations do
      it 'supports the addition with point' do
        expect(point + Point.new(1, 1)).to eq point.add(1, 1)
        expect(point + Point.new(-1, -1)).to eq point.add(-1, -1)
        expect(point + Point.new(0, 0)).to eq point
      end

      it 'supports the subtraction with point' do
        expect(point - Point.new(1, 1)).to eq point.add(-1, -1)
        expect(point - Point.new(-1, -1)).to eq point.add(1, 1)
        expect(point - Point.new(0, 0)).to eq point
      end

      it 'supports the division by a number' do
        expect(point / 1.0).to eq point
        expect(point / 2.0).to eq Point.new(0.5, 0.25)
        expect(point / -1.0).to eq Point.new(-1, -0.5)
        expect { point / 0 }.to raise_error ZeroDivisionError
      end

      it 'adds new x and y to a point (bang)' do
        point.add!(2, 0.3)
        expect(point.x).to eq 3
        expect(point.y).to eq 0.8
      end

      it 'adds new x and y to a point' do
        new_point = point.add(2, 0.3)
        expect(point.x).to eq 1
        expect(point.y).to eq 0.5

        expect(new_point.x).to eq 3
        expect(new_point.y).to eq 0.8
      end

      it 'translates a point' do
        new_point = point.translate(0.0, 100.0)
        expect(new_point.x).to be_within(10e-6).of  101.0
        expect(new_point.y).to be_within(10e-6).of  0.5

        new_point = point.translate(Math::PI, 100.0)
        expect(new_point.x).to be_within(10e-6).of(-99.0)
        expect(new_point.y).to be_within(10e-6).of  0.5

        new_point = point.translate(Math::PI / 2.0, 100.0)
        expect(new_point.x).to be_within(10e-6).of  1.0
        expect(new_point.y).to be_within(10e-6).of  100.5

        new_point = point.translate(3.0 * Math::PI / 2.0, 100.0)
        expect(new_point.x).to be_within(10e-6).of 1.0
        expect(new_point.y).to be_within(10e-6).of(-99.5)

        new_point = point.translate(20 * Math::PI, 100.0)
        expect(new_point.x).to be_within(10e-6).of  101.0
        expect(new_point.y).to be_within(10e-6).of  0.5
      end

      it 'rounds the point' do
        expect(Point.new(1.23456, 3.456789).round(1)).to eq Point.new(1.2, 3.5)
        expect(Point.new(1.23456, 3.456789).round(2)).to eq Point.new(1.23, 3.46)
      end

      it 'return the absolute point' do
        expect(point.abs).to eq point
        expect(Point.new(-1.0, -3.5).abs).to eq Point.new(1.0, 3.5)
        expect(Point.new(1.0, -3.5).abs).to eq Point.new(1.0, 3.5)
        expect(Point.new(-1.0, 3.5).abs).to eq Point.new(1.0, 3.5)
      end

      it 'returns an array of the 2 coordinates' do
        expect(point.xy).to eq [point.x, point.y]
      end

      it 'returns the string representation of a point' do
        expect(point.to_s).to eq '1.0:0.5'
      end
    end

    describe :comparision do
      it 'tests the equality of 2 points' do
        expect(Point.new(1, 2) == Point.new(1, 2)).to be true # rubocop: disable Lint/UselessComparison
        expect(Point.new(1.0, 2.0) == Point.new(1, 2)).to be true
        expect(Point.new(1, 2) == Point.new(2, 1)).to be false
      end

      it 'tests the non-equality of 2 points' do
        expect(Point.new(1, 2) != Point.new(1, 2)).to be false # rubocop: disable Lint/UselessComparison
        expect(Point.new(1.0, 2.0) != Point.new(1, 2)).to be false
        expect(Point.new(1, 2) != Point.new(2, 1)).to be true
      end
    end

    describe :dist do
      it 'calculates the distance between two points' do
        expect(point.dist(Point.new(0, 0))).to eq Math.hypot(1, 0.5)
        expect(point.dist(Point.new(1, 0))).to eq Math.hypot(0, 0.5)
        expect(point.dist(Point.new(-10, 0))).to eq Math.hypot(11, 0.5)
        expect(point.dist(Point.new(0, 1))).to eq Math.hypot(1, -0.5)
        expect(point.dist(Point.new(0, -10))).to eq Math.hypot(1, 10.5)
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
