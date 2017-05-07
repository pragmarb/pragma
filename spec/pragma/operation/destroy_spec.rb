# frozen_string_literal: true

RSpec.describe Pragma::Operation::Destroy do
  subject(:result) do
    described_class.call(
      params,
      'current_user' => current_user,
      'model.class' => model_klass,
      'policy.default.class' => policy_klass
    )
  end

  let(:params) do
    { id: 1 }
  end

  let(:current_user) { OpenStruct.new(id: 1) }

  let(:model_klass) do
    Class.new(OpenStruct) do
      def self.find_by(conditions)
        OpenStruct.new(user_id: 1, destroy: true) if conditions[:id] == 1
      end
    end
  end

  let(:policy_klass) do
    Class.new(Pragma::Policy::Base) do
      def destroy?
        user.id == 1
      end
    end
  end

  it 'responds with 204 No Content' do
    expect(result['result.response'].status).to eq(204)
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
