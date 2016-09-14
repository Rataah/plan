module Plan
  describe :geometry do
    describe :bounds do
      let(:points) do
        [
          Point.new(1, 10),
          Point.new(-13, -3),
          Point.new(-6, 5),
          Point.new(13, 2),
          Point.new(4, -7)
        ]
      end

      it 'determines the bounds of an array of Points' do
        expect(Plan.bounds(points)).to eq [Point.new(-13, -7), Point.new(13, 10)]
      end

      it 'determines the center of the bounds of an array of Points' do
        expect(Plan.center(points)).to eq Point.new(0, 1.5)
      end
    end

    describe :position_against do
      let(:segment) do
        [Point.new(1, 1), Point.new(6, 6)]
      end

      it 'returns a positive value is the point is above the segment' do
        expect(Plan.position_against(Point.new(4, 30), segment.first, segment.last)).to be > 0
        expect(Plan.position_against(Point.new(1, 2), segment.first, segment.last)).to be > 0
        expect(Plan.position_against(Point.new(6, 7), segment.first, segment.last)).to be > 0
        expect(Plan.position_against(Point.new(2.999999, 3), segment.first, segment.last)).to be > 0

        # work even if for a point above the corresponding line instead of the segment
        expect(Plan.position_against(Point.new(10, 50), segment.first, segment.last)).to be > 0
        expect(Plan.position_against(Point.new(-10_000, -9_999), segment.first, segment.last)).to be > 0
      end

      it 'returns a negative value is the point is below the segment' do
        expect(Plan.position_against(Point.new(4, 3), segment.first, segment.last)).to be < 0
        expect(Plan.position_against(Point.new(1, 0), segment.first, segment.last)).to be < 0
        expect(Plan.position_against(Point.new(6, 5), segment.first, segment.last)).to be < 0
        expect(Plan.position_against(Point.new(3.000001, 3), segment.first, segment.last)).to be < 0

        # work even if for a point above the corresponding line instead of the segment
        expect(Plan.position_against(Point.new(10, -50), segment.first, segment.last)).to be < 0
        expect(Plan.position_against(Point.new(-10_000, -10_001), segment.first, segment.last)).to be < 0
      end

      it 'returns zero is the point is on the segment' do
        expect(Plan.position_against(Point.new(4, 4), segment.first, segment.last)).to be 0
        expect(Plan.position_against(Point.new(1, 1), segment.first, segment.last)).to be 0
        expect(Plan.position_against(Point.new(6, 6), segment.first, segment.last)).to be 0
        expect(Plan.position_against(Point.new(3.000001, 3.000001), segment.first, segment.last)).to be 0

        # work even if for a point above the corresponding line instead of the segment
        expect(Plan.position_against(Point.new(50, 50), segment.first, segment.last)).to be 0
        expect(Plan.position_against(Point.new(-10_000, -10_000), segment.first, segment.last)).to be 0
      end
    end

    describe :angle_aligned? do
      let(:half_pi) { Math::PI / 2.0 }
      let(:angle) { half_pi }

      it 'check if 2 angles are aligned' do
        expect(Plan.angle_aligned?(angle, half_pi)).to be true
        expect(Plan.angle_aligned?(angle, 3.0 * half_pi)).to be true
        expect(Plan.angle_aligned?(angle, 101.0 * half_pi)).to be true
      end
    end
  end
end
