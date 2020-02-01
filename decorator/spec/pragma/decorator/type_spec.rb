# frozen_string_literal: true

RSpec.describe Pragma::Decorator::Type do
  subject { decorator_klass.new(model) }

  let(:decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      include Pragma::Decorator::Type
    end
  end

  let(:model) { OpenStruct.new }

  let(:result) { JSON.parse(subject.to_json) }

  it 'includes the object type' do
    expect(result).to include('type' => 'open_struct')
  end

  context 'when the model is overridden' do
    let(:model) { %i[foo bar] }

    it 'uses the overridden type' do
      expect(result).to include('type' => 'list')
    end
  end

  context 'when using a custom override' do
    before do
      described_class.overrides['OpenStruct'] = 'my_override'
    end

    it 'uses the overridden type' do
      expect(result).to include('type' => 'my_override')
    end
  end
end
