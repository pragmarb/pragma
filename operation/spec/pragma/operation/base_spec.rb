# frozen_string_literal: true

RSpec.describe Pragma::Operation::Base do
  subject(:result) do
    operation_klass.call(
      { foo: 'bar' },
      'current_user_id' => 1
    )
  end

  let(:operation_klass) do
    Class.new(described_class) do
      step :process!

      def process!(_options, **)
        true
      end
    end
  end

  it 'runs correctly' do
    expect(result).to be_success
  end
end
