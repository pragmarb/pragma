# frozen_string_literal: true
RSpec.describe Pragma::Operation::Show do
  subject(:result) do
    described_class.call(
      { 'id' => 1 },
      {
        'current_user' => current_user,
        'model.class' => model_klass,
        'decorator.default.class' => decorator_klass,
        'policy.default.class' => policy_klass
      }
    )
  end

  let(:current_user) { Object.new }

  let(:model_klass) do
    Class.new do
      def self.find(id)
        OpenStruct.new if id == 1
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
      end

      def show?
        true
      end
    end
  end

  it 'runs correctly' do
    expect(result).to be_success
  end
end
