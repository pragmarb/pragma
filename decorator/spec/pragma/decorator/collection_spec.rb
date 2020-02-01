# frozen_string_literal: true

RSpec.describe Pragma::Decorator::Collection do
  subject { decorator.new(collection) }

  let(:collection) { [OpenStruct.new(foo: 'bar')] }

  context 'with the inferred instance decorator' do
    before do
      module CollectionTest
        class Collection < Pragma::Decorator::Base
          include Pragma::Decorator::Collection
        end

        class Instance < Pragma::Decorator::Base
          property :foo
        end
      end
    end

    let(:decorator) { CollectionTest::Collection }

    it 'renders the collection' do
      expect(JSON.parse(subject.to_json)).to match('data' => [
                                                     'foo' => 'bar'
                                                   ])
    end
  end

  context 'with a custom instance decorator' do
    before do
      module CollectionTest
        class CustomInstance < Pragma::Decorator::Base
          property :foo, as: :qux
        end

        class CustomCollection < Pragma::Decorator::Base
          include Pragma::Decorator::Collection
          decorate_with CustomInstance
        end
      end
    end

    let(:decorator) { CollectionTest::CustomCollection }

    it 'renders the collection' do
      expect(JSON.parse(subject.to_json)).to match('data' => [
                                                     'qux' => 'bar'
                                                   ])
    end
  end
end
