module Plan
  describe String do
    describe :to_id do
      it 'transform a string into an valid xml ID' do
        expect('an_id'.to_id).to eq 'an_id'
        expect('other.id'.to_id).to eq 'other.id'
        expect('an id'.to_id).to eq 'an_id'
        expect('an:id'.to_id).to eq 'an_id'
        expect('-an: other id'.to_id).to eq 'an__other_id'
      end
    end
  end
end
