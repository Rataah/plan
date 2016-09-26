require 'plan'

module Plan
  describe SVGElement do
    describe :xml_element do
      let(:xml_builder) { double('xml_builder') }
      subject(:element) { SVGElement.new('unit_test', 'ut_id') }

      before :each do
        expect(xml_builder).to receive(:comment).with('this is the comment')
        expect(xml_builder).to receive(:unit_test_).with(nil, 'id' => 'ut_id', 'arg1' => 'value1', 'arg2' => '1.0')
      end

      it 'builds the XML element' do
        element.args['arg1'] = SVGArg.new('value1', false)
        element.args['arg2'] = SVGArg.new(1.0, true)
        element.comments 'this is the comment'

        expect(element.xml_element(xml_builder))
      end
    end

    describe :prepare_value do
      it 'prepares the value for XML element' do
        expect(SVGElement.prepare_value('this is a string')).to eq 'this is a string'
        expect(SVGElement.prepare_value(%w(this is a string))).to eq 'this is a string'
        expect(SVGElement.prepare_value(Point.new(1.23, 4.56))).to eq '1.23,4.56'
        expect(SVGElement.prepare_value(1)).to eq '1.0'
        expect(SVGElement.prepare_value(2.34)).to eq '2.34'
        expect(SVGElement.prepare_value([Point.new(1.23, 4.56), Point.new(7.89, 10.11)])).to eq '1.23,4.56 7.89,10.11'
      end
    end
  end
end
