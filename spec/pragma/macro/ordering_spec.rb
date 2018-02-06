# frozen_string_literal: true

RSpec.describe Pragma::Macro::Ordering do
  subject(:result) do
    OrderingMacroTest::Operation.call(params, options)
  end

  let(:options) { {} }
  let(:params) { {} }

  before do
    module OrderingMacroTest
      class Model < Array
        def order(conditions)
          column, direction = conditions.split(' ').map(&:to_sym)

          records = sort_by { |r| column.to_s.split('.').inject(r, :send) }

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
        step Pragma::Macro::Ordering()

        self['ordering.columns'] = %w[name rating album.name]
        self['ordering.default_column'] = 'rating'
        self['ordering.default_direction'] = 'desc'
        self['ordering.column_param'] = :ordercol
        self['ordering.direction_param'] = :orderdir

        def model!(options)
          options['model'] = Model.new([
            OpenStruct.new(
              name: 'Hole to Feed',
              rating: 4,
              album: OpenStruct.new(name: 'Sounds of the Universe')
            ),
            OpenStruct.new(
              name: 'In Chains',
              rating: 3,
              album: OpenStruct.new(name: 'Sounds of the Universe')
            ),
            OpenStruct.new(
              name: 'Never Let Me Down Again',
              rating: 5,
              album: OpenStruct.new(name: 'Music for the Masses')
            )
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

  context 'when column is namespaced' do
    let(:params) do
      {
        ordercol: 'album.name',
        orderdir: 'asc'
      }
    end

    it 'orders by given association' do
      expect(result['model'].map(&:name)).to eq([
        'Never Let Me Down Again',
        'Hole to Feed',
        'In Chains'
      ])
    end
  end

  context 'with custom ordering parameters' do
    let(:params) do
      {
        ordercol: 'name',
        orderdir: 'asc'
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
        orderdir: 'asc'
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
        orderdir: 'invalid'
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end
  end
end
