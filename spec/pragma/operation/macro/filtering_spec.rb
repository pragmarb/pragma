RSpec.describe Pragma::Operation::Macro::Filtering do
  subject(:result) do
    FilteringMacroTest::Operation.(params, options)
  end

  let(:options) { {} }
  let(:params) do
    {
      by_name: 'In Chains',
    }
  end

  before do
    module FilteringMacroTest
      class TestFilter < Pragma::Operation::Filter::Base
        def apply(relation:, value:)
          relation.select do |instance|
            instance.send(column) == value
          end
        end
      end

      class Operation < Pragma::Operation::Base
        self['filtering.filters'] = [
          TestFilter.new(param: :by_name, column: :name)
        ]

        step :model!
        step Pragma::Operation::Macro::Filtering()

        def model!(options)
          options['model'] = [
            OpenStruct.new(name: 'In Chains'),
            OpenStruct.new(name: 'Hole to Feed'),
          ]
        end
      end
    end
  end

  it 'filters with the given filters' do
    expect(result['model'].map(&:name)).to eq(['In Chains'])
  end
end
