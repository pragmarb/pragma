# frozen_string_literal: true

RSpec.describe Pragma::Filter::Where do
  subject { described_class.new(param: :custom_param, condition: 'custom_param = :value') }

  let(:relation) do
    Class.new do
      def where(*); end
    end.new
  end

  it 'can be applied properly' do
    expect(relation).to receive(:where)
      .with('custom_param = :value', value: 'foo')
      .once

    subject.apply(relation: relation, value: 'foo')
  end
end
