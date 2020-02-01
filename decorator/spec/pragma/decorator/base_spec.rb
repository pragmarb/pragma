# frozen_string_literal: true

RSpec.describe Pragma::Decorator::Base do
  subject { decorator_klass.new(model) }

  let(:decorator_klass) do
    Class.new(described_class) do
      property :title
      property :listened_at
    end
  end

  let(:model) { OpenStruct.new(title: 'Wonderful World', listened_at: nil) }
  let(:result) { JSON.parse(subject.to_json) }

  it 'instantiates correctly' do
    expect { subject }.not_to raise_error
  end

  it 'renders JSON' do
    expect(result).to include('title' => 'Wonderful World')
  end

  it 'renders nil properties' do
    expect(result).to include('listened_at' => nil)
  end
end
