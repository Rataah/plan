module Plan
  describe Array do
    it 'return the first and the last element' do
      expect([1, 2, 3, 4, 5].first_and_last).to eq [1, 5]
      expect([1, 2].first_and_last).to eq [1, 2]
      expect([1].first_and_last).to eq [1, 1]
      expect([].first_and_last).to eq [nil, nil]
    end

    it 'duplicate with inner objects' do
      array = [1, 'string', Point.new(1, 1)]
      duplicated_array = array.deep_dup

      expect(duplicated_array[0]).to eq array[0]
      expect(duplicated_array[0].object_id).to eq array[0].object_id
      expect(duplicated_array[1]).to eq array[1]
      expect(duplicated_array[1].object_id).not_to eq array[1].object_id
      expect(duplicated_array[2]).to eq array[2]
      expect(duplicated_array[2].object_id).not_to eq array[2].object_id
    end
  end
end
