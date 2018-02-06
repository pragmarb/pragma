# frozen_string_literal: true

RSpec.describe Pragma::Filter::Like do
  subject { described_class.new(param: :by_title, column: :title) }

  let(:relation) do
    Class.new do
      def where(*); end
    end.new
  end

  it 'can be applied properly' do
    expect(relation).to receive(:where)
      .with('title LIKE ?', '%foo%')
      .once

    subject.apply(relation: relation, value: 'foo')
  end
end
