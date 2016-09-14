module Plan
  describe :symbolize_keys do
    subject(:hash) do
      {
        'test1' => 1,
        test2: 2,
        test3: [1, 2, 3, { 'test5' => 'value' }],
        test4: {
          'test6' => 1,
          test7: 2
        }
      }
    end

    it 'is possible to access with symbol' do
      expect(hash['test1']).to eq 1
      expect(hash[:test1]).to be nil

      symbolized_hash = Plan.symbolize_keys(hash)
      expect(symbolized_hash[:test1]).to eq 1
      expect(symbolized_hash[:test3].last[:test5]).to eq 'value'
      expect(symbolized_hash[:test4][:test6]).to eq 1
    end
  end
end
