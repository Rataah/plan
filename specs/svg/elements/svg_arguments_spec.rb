require 'plan'

module Plan
  describe SVGArgument do
    subject(:element) { SVGElement.new('unit_test') }

    it 'set the id of the element' do
      expect(element.id('ut_id')).to eq element
      expect(element.args['id']).to eq SVGArg.new('ut_id', false)
    end

    it 'set the stroke width of the element' do
      expect(element.stroke_width(1.5)).to eq element
      expect(element.args['stroke-width']).to eq SVGArg.new(1.5, true)
    end

    it 'set the stroke color of the element' do
      expect(element.stroke).to eq element
      expect(element.args['stroke']).to eq SVGArg.new('black', false)

      expect(element.stroke('red')).to eq element
      expect(element.args['stroke']).to eq SVGArg.new('red', false)
    end

    it 'set the fill color of the element' do
      expect(element.fill('green')).to eq element
      expect(element.args['fill']).to eq SVGArg.new('green', false)
    end

    it 'set the opacity of the element' do
      expect(element.opacity(0.6)).to eq element
      expect(element.args['opacity']).to eq SVGArg.new(0.6, false)
    end

    it 'set the comment on the element' do
      expect(element.comments('this is a comment')).to eq element
      expect(element.xml_comments).to eq 'this is a comment'
    end

    it 'set the css class of the element' do
      expect(element.css_class('class1')).to eq element
      expect(element.args['class']).to eq SVGArg.new('class1', false)

      expect(element.css_class('class2')).to eq element
      expect(element.css_class('class3')).to eq element
      expect(element.css_class('class4')).to eq element
      expect(element.args['class']).to eq SVGArg.new('class1 class2 class3 class4', false)
    end

    describe :merge! do
      it 'merge svg arguments' do
        element.fill('red').merge!(SVGElement.new('test').stroke_width(2.0))
        expect(element.args.keys).to eq %w(fill stroke-width)

        element.merge!(SVGElement.new('test').fill('green'))
        expect(element.args['fill']).to eq SVGArg.new('green', false)
      end
    end
  end
end
