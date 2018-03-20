# frozen_string_literal: true

RSpec.describe Pragma::Filter::Boolean do
  subject { described_class.new(param: :enabled, scope: :with_enabled) }

  let(:relation) do
    Class.new do
      def with_enabled(val); end
    end.new
  end

  it 'can be applied properly' do
    expect(relation).to receive(:with_enabled).once
    subject.apply(relation: relation, value: '1')
  end
end
