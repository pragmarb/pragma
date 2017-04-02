# frozen_string_literal: true

RSpec.describe Pragma::Operation::Index do
  subject(:result) do
    described_class.call(
      params,
      'current_user' => current_user,
      'model.class' => model_klass,
      'decorator.default.class' => decorator_klass,
      'policy.default.class' => policy_klass
    )
  end

  let(:params) do
    { 'id' => 1 }
  end

  let(:current_user) { OpenStruct.new(id: 1) }

  let(:model_klass) do
    Class.new do
      def self.all
        [
          OpenStruct.new(user_id: 1),
          OpenStruct.new(user_id: 2)
        ]
      end
    end
  end

  let(:decorator_klass) { Class.new(Pragma::Decorator::Base) }
  let(:policy_klass) do
    Class.new(Pragma::Policy::Base) do
      def self.foo
        'bar'
      end

      class Scope < Pragma::Policy::Base::Scope
        def resolve
          scope.select { |i| i.user_id == user.id }
        end
      end
    end
  end

  it 'responds with 200 OK' do
    expect(result['result.response'].status).to eq(200)
  end

  it 'filters the records with the policy' do
    expect(result['result.response'].entity.count).to eq(1)
  end

  it 'adds pagination headers' do
    expect(result['result.response'].headers).to match(a_hash_including(
      'Page' => 1,
      'Per-Page' => 30,
      'Total' => 1
    ))
  end
end
