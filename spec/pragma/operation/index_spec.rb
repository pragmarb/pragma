# frozen_string_literal: true

RSpec.describe Pragma::Operation::Index do
  subject(:result) do
    described_class.call(
      params,
      'current_user' => current_user,
      'model.class' => model_klass,
      'decorator.default.class' => decorator_klass,
      'policy.default.scope.class' => policy_scope_klass
    )
  end

  let(:params) { {} }

  let(:current_user) { OpenStruct.new(id: 1) }

  let(:model_klass) do
    Class.new do
      def self.all
        [
          OpenStruct.new(id: 1, user_id: 1),
          OpenStruct.new(id: 2, user_id: 2),
          OpenStruct.new(id: 3, user_id: 1)
        ]
      end
    end
  end

  let(:decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      property :id
      property :user_id
    end
  end

  let(:policy_scope_klass) do
    Class.new(Pragma::Policy::Base::Scope) do
      def resolve
        scope.select { |i| i.user_id == user.id }
      end
    end
  end

  it 'responds with 200 OK' do
    expect(result['result.response'].status).to eq(200)
  end

  it 'filters the records with the policy' do
    expect(result['result.response'].entity.represented.count).to eq(2)
  end

  it 'adds default pagination headers' do
    expect(result['result.response'].headers).to match(a_hash_including(
      'Page' => 1,
      'Per-Page' => 30,
      'Total' => 2
    ))
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

    it 'adds the expected pagination headers' do
      expect(result['result.response'].headers).to match(a_hash_including(
        'Page' => 2,
        'Per-Page' => 1,
        'Total' => 2
      ))
    end

    it 'paginates with the provided parameters' do
      expect(result['result.response'].entity.to_hash).to match_array([
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

    it 'adds the expected pagination headers' do
      expect(result['result.response'].headers).to match(a_hash_including(
        'Page' => 2,
        'Per-Page' => 1,
        'Total' => 2
      ))
    end

    it 'paginates with the provided parameters' do
      expect(result['result.response'].entity.to_hash).to match_array([
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
