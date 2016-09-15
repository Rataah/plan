module Plan
  describe Numeric do
    describe :rad do
      it 'translate a degree in radian' do
        expect(0.rad).to eq 0.0
        expect(180.rad).to eq Math::PI
        expect(360.rad).to eq 0.0
        expect(90.rad).to eq Math::PI / 2.0
        expect(540.rad).to eq Math::PI
        expect(1080.rad).to eq 0.0
      end
    end

    describe :deg do
      it 'translate a radian in degree' do
        expect(0.deg).to eq 0.0
        expect(Math::PI.deg).to eq 180.0
        expect((2 * Math::PI).deg).to eq 0.0
        expect((Math::PI / 2.0).deg).to eq 90.0
        expect((3 * Math::PI).deg).to eq 180.0
        expect((10_000 * Math::PI).deg).to eq 0.0
      end
    end
  end
end
