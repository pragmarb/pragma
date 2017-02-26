# frozen_string_literal: true
RSpec.describe Pragma::Operation::Show do
  subject(:result) do
    described_class.call(
      params,
      {
        'current_user' => current_user,
        'model.class' => model_klass,
        'decorator.default.class' => decorator_klass,
        'policy.default.class' => policy_klass
      }
    )
  end

  let(:params) do
    { 'id' => 1 }
  end

  let(:current_user) { OpenStruct.new(id: 1) }

  let(:model_klass) do
    Class.new do
      def self.find_by(conditions)
        OpenStruct.new(user_id: 1) if conditions[:id] == 1
      end
    end
  end

  let(:decorator_klass) do
    Class.new do
      def self.represent(object)
        object
      end
    end
  end

  let(:policy_klass) do
    Class.new do
      def initialize(user:, resource:)
        @user = user
        @resource = resource
      end

      def show?
        @resource.user_id == @user.id
      end
    end
  end

  it 'responds with 200 OK' do
    expect(result['result.response'].status).to eq(200)
  end

  it 'responds with the decorated resource' do
    expect(result['result.response'].entity).to be_instance_of(OpenStruct)
  end

  context 'when the model cannot be found' do
    let(:params) do
      { 'id' => 2 }
    end

    it 'responds with 404 Not Found' do
      expect(result['result.response'].status).to eq(404)
    end
  end

  context 'when the user is not authorized' do
    let(:current_user) { OpenStruct.new(id: 2) }

    it 'responds with 403 Forbidden' do
      expect(result['result.response'].status).to eq(403)
    end
  end
end
