# frozen_string_literal: true

RSpec.describe Pragma::Filter::Equals do
  subject { described_class.new(param: :by_category, column: :category) }

  let(:relation) do
    Class.new do
      def where(*); end
    end.new
  end

  it 'can be applied properly' do
    expect(relation).to receive(:where)
      .with(category: 'foo')
      .once

    subject.apply(relation: relation, value: 'foo')
  end
end
