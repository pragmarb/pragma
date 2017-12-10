# frozen_string_literal: true

RSpec.describe Pragma::Operation::Index do
  subject(:result) do
    described_class.call(
      params,
      'current_user' => current_user,
      'model.class' => model_klass,
      'decorator.collection.class' => collection_decorator_klass,
      'decorator.instance.class' => instance_decorator_klass,
      'policy.default.scope.class' => policy_scope_klass,
      'ordering.order_columns' => %i[created_at id],
      'ordering.default_column' => :id,
      'ordering.default_direction' => :asc,
      'filtering.filters' => [
        Pragma::Operation::Filter::Equals.new(param: :by_title, column: :title)
      ]
    )
  end

  let(:params) { {} }

  let(:current_user) { OpenStruct.new(id: 1) }

  let(:model_klass) do
    Class.new do
      def self.all
        [
          OpenStruct.new(id: 2, title: 'In Chains', user_id: 2, created_at: Time.now.to_i - 3600),
          OpenStruct.new(id: 3, title: 'Little Soul', user_id: 1, created_at: Time.now.to_i - 1800),
          OpenStruct.new(id: 1, title: 'Wrong', user_id: 1, created_at: Time.now.to_i)
        ]
      end
    end
  end

  let(:collection_decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      include Pragma::Decorator::Pagination
      include Pragma::Decorator::Collection
    end.tap do |klass|
      klass.send(:decorate_with, instance_decorator_klass)
    end
  end

  let(:instance_decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      property :id
      property :user_id
      property :title
    end
  end

  let(:policy_scope_klass) do
    Class.new(Pragma::Policy::Base::Scope) do
      def resolve
        relation = Class.new(Array) do
          def order(conditions)
            ret = self

            ret = case conditions.keys.first.to_sym
                  when :id
                    ret.sort_by(&:id)
                  when :created_at
                    ret.sort_by(&:created_at)
                  else
                    ret
            end

            ret = ret.reverse if conditions.values.first.to_sym == :desc

            self.class.new(ret)
          end

          def where(conditions)
            self.class.new(
              select { |r| r.send(conditions.keys.first) == conditions.values.first }
            )
          end
        end

        relation.new(scope.select { |i| i.user_id == user.id })
      end
    end
  end

  it 'responds with 200 OK' do
    expect(result['result.response'].status).to eq(200)
  end

  it 'filters the records with the policy' do
    expect(result['result.response'].entity.represented.count).to eq(2)
  end

  it 'adds pagination info to the response' do
    expect(result['result.response'].entity.to_hash).to match(a_hash_including(
      'current_page' => 1,
      'per_page' => 30,
      'total_entries' => 2
    ))
  end

  it 'orders properly' do
    expect(result['result.response'].entity.to_hash['data']).to match([
      a_hash_including('id' => 1),
      a_hash_including('id' => 3)
    ])
  end

  context 'when applying a filter' do
    let(:params) do
      {
        by_title: 'Wrong'
      }
    end

    it 'filters properly' do
      expect(result['result.response'].entity.to_hash['data']).to match([
        a_hash_including('title' => 'Wrong')
      ])
    end
  end
  context 'with a different order column and direction' do
    let(:params) do
      {
        order_column: 'created_at',
        order_direction: 'desc'
      }
    end

    it 'orders properly' do
      expect(result['result.response'].entity.to_hash['data']).to match([
        a_hash_including('id' => 3),
        a_hash_including('id' => 1)
      ])
    end
  end

  context 'with integer pagination parameters' do
    let(:params) do
      {
        page: 2,
        per_page: 1
      }
    end

    it 'responds with 200 OK' do
      expect(result['result.response'].status).to eq(200)
    end

    it 'adds the expected pagination info to the response' do
      expect(result['result.response'].entity.to_hash).to match(a_hash_including(
        'current_page' => 2,
        'per_page' => 1,
        'total_entries' => 2,
        'previous_page' => 1
      ))
    end

    it 'paginates with the provided parameters' do
      expect(result['result.response'].entity.to_hash['data']).to match_array([
        a_hash_including('id' => 3)
      ])
    end
  end

  context 'with string pagination parameters' do
    let(:params) do
      {
        page: '2',
        per_page: '1'
      }
    end

    it 'responds with 200 OK' do
      expect(result['result.response'].status).to eq(200)
    end

    it 'adds the expected pagination info to the response' do
      expect(result['result.response'].entity.to_hash).to match(a_hash_including(
        'current_page' => 2,
        'per_page' => 1,
        'total_entries' => 2
      ))
    end

    it 'paginates with the provided parameters' do
      expect(result['result.response'].entity.to_hash['data']).to match_array([
        a_hash_including('id' => 3)
      ])
    end
  end

  context 'with 0 integer as the page number' do
    let(:params) do
      { page: 0 }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end

    it 'decorates the error' do
      expect(result['result.response'].entity).to be_kind_of(Pragma::Decorator::Error)
    end
  end

  context 'with 0 integer as the per_page number' do
    let(:params) do
      { page: 0 }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end

    it 'decorates the error' do
      expect(result['result.response'].entity).to be_kind_of(Pragma::Decorator::Error)
    end
  end

  context 'with 0 string as the page number' do
    let(:params) do
      { page: '0' }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end

    it 'decorates the error' do
      expect(result['result.response'].entity).to be_kind_of(Pragma::Decorator::Error)
    end
  end

  context 'with 0 string as the per_page number' do
    let(:params) do
      { per_page: '0' }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end

    it 'decorates the error' do
      expect(result['result.response'].entity).to be_kind_of(Pragma::Decorator::Error)
    end
  end

  context 'with a plain string as the expand parameter' do
    let(:params) do
      { expand: 'foo' }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end

    it 'decorates the error' do
      expect(result['result.response'].entity).to be_kind_of(Pragma::Decorator::Error)
    end
  end
end
