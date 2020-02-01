# frozen_string_literal: true

RSpec.describe Pragma::Resource::Operation::Update do
  subject(:result) do
    described_class.call(
      params,
      'current_user' => current_user,
      'model.class' => model_klass,
      'decorator.instance.class' => decorator_klass,
      'policy.default.class' => policy_klass,
      'contract.default.class' => contract_klass
    )
  end

  let(:params) do
    {
      id: 1,
      title: 'My New Post'
    }
  end

  let(:current_user) { OpenStruct.new(id: 1) }

  let(:model_klass) do
    Class.new(OpenStruct) do
      def self.find_by(conditions)
        OpenStruct.new(user_id: 1, save: true) if conditions[:id] == 1
      end
    end
  end

  let(:decorator_klass) do
    Class.new(Pragma::Decorator::Base)
  end

  let(:policy_klass) do
    Class.new(Pragma::Policy::Base) do
      def update?
        user.id == 1
      end
    end
  end

  let(:contract_klass) do
    Class.new(Pragma::Contract::Base) do
      property :title

      validation do
        required(:title).filled(:str?)
      end
    end
  end

  it 'responds with 200 OK' do
    expect(result['result.response'].status).to eq(200)
  end

  it 'decorates the response entity' do
    expect(result['result.response'].entity).to be_kind_of(Pragma::Decorator::Base)
  end

  context 'when the model cannot be found' do
    let(:params) do
      { id: 2 }
    end

    it 'responds with 404 Not Found' do
      expect(result['result.response'].status).to eq(404)
    end

    it 'decorates the entity' do
      expect(result['result.response'].entity).to be_kind_of(Pragma::Decorator::Error)
    end
  end

  context 'when validation fails' do
    let(:params) do
      { id: 1, title: '' }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end

    it 'decorates the error' do
      expect(result['result.response'].entity).to be_kind_of(Pragma::Decorator::Error)
    end
  end

  context 'when the user is not authorized' do
    let(:current_user) { OpenStruct.new(id: 2) }

    it 'responds with 403 Forbidden' do
      expect(result['result.response'].status).to eq(403)
    end

    it 'decorates the error' do
      expect(result['result.response'].entity).to be_kind_of(Pragma::Decorator::Error)
    end
  end
end
