RSpec.describe Pragma::Operation::Macro::Ordering do
  subject(:result) do
    OrderingMacroTest::Operation.(params, options)
  end

  let(:options) { {} }
  let(:params) { {} }

  before do
    module OrderingMacroTest
      class Model < Array
        def order(conditions)
          column, direction = conditions.first.map(&:to_sym)

          records = sort_by(&:"#{column}")

          records = case direction
          when :desc
            records.reverse
          else
            records
          end

          self.class.new records
        end
      end

      class Operation < Pragma::Operation::Base
        step :model!
        step Pragma::Operation::Macro::Ordering()

        self['ordering.columns'] = %w[name rating]
        self['ordering.default_column'] = 'rating'
        self['ordering.default_direction'] = 'desc'
        self['ordering.column_param'] = :ordercol
        self['ordering.direction_param'] = :orderdir

        def model!(options)
          options['model'] = Model.new([
            OpenStruct.new(name: 'Hole to Feed', rating: 4),
            OpenStruct.new(name: 'In Chains', rating: 3),
            OpenStruct.new(name: 'Never Let Me Down Again', rating: 5),
          ])
        end
      end
    end
  end

  it 'applies default ordering' do
    expect(result['model'].map(&:name)).to eq([
      'Never Let Me Down Again',
      'Hole to Feed',
      'In Chains'
    ])
  end

  context 'with custom ordering parameters' do
    let(:params) do
      {
        ordercol: 'name',
        orderdir: 'asc',
      }
    end

    it 'orders with the given column and direction' do
      expect(result['model'].map(&:name)).to eq([
        'Hole to Feed',
        'In Chains',
        'Never Let Me Down Again'
      ])
    end
  end

  context 'when passing an invalid order column' do
    let(:params) do
      {
        ordercol: 'invalid',
        orderdir: 'asc',
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end
  end

  context 'when passing an invalid order direction' do
    let(:params) do
      {
        ordercol: 'name',
        orderdir: 'invalid',
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end
  end
end
