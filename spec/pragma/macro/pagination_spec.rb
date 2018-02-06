# frozen_string_literal: true

RSpec.describe Pragma::Macro::Pagination do
  subject(:result) do
    PaginationMacroTest::Operation.call(params, options)
  end

  let(:options) { {} }
  let(:params) { {} }

  before do
    module PaginationMacroTest
      class Model < Array
        def paginate(page:, per_page:)
          self.class.new(each_slice(per_page).to_a[page - 1])
        end
      end

      class Operation < Pragma::Operation::Base
        step :model!
        step Pragma::Macro::Pagination()

        self['pagination.default_per_page'] = 2
        self['pagination.max_per_page'] = 99
        self['pagination.page_param'] = :p
        self['pagination.per_page_param'] = :per_p

        def model!(options)
          options['model'] = Model.new([
            OpenStruct.new(name: 'Hole to Feed'),
            OpenStruct.new(name: 'In Chains'),
            OpenStruct.new(name: 'Never Let Me Down Again')
          ])
        end
      end
    end
  end

  it 'applies default pagination' do
    expect(result['model'].map(&:name)).to match_array([
      'Hole to Feed',
      'In Chains'
    ])
  end

  context 'with custom pagination parameters' do
    let(:params) do
      {
        per_p: 1,
        p: 3
      }
    end

    it 'paginates with the given parameters' do
      expect(result['model'].map(&:name)).to match_array([
        'Never Let Me Down Again'
      ])
    end
  end

  context 'when passing a string as the page number' do
    let(:params) do
      {
        p: '1'
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['model'].map(&:name)).to match_array([
        'Hole to Feed',
        'In Chains'
      ])
    end
  end

  context 'when passing a string as the per_page number' do
    let(:params) do
      {
        per_p: '2'
      }
    end

    it 'paginates successfully' do
      expect(result['model'].map(&:name)).to match_array([
        'Hole to Feed',
        'In Chains'
      ])
    end
  end

  context 'when passing 0 as the page number' do
    let(:params) do
      {
        p: 0
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end
  end

  context 'when passing 0 as the per_page number' do
    let(:params) do
      {
        per_p: 0
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end
  end

  context 'when passing a per_page number that is too large' do
    let(:params) do
      {
        per_p: 100
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end
  end
end
