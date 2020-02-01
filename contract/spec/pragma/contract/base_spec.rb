# frozen_string_literal: true

RSpec.describe Pragma::Contract::Base do
  subject { form_klass.new(model) }

  let(:form_klass) do
    Class.new(described_class) do
      property :title, type: coercible(:string)

      collection :songs do
        property :title, type: coercible(:string)
      end

      validation do
        required(:title).filled
      end
    end
  end

  let(:model) { OpenStruct.new(songs: [OpenStruct.new]) }

  it 'is instantiated correctly' do
    expect { subject }.not_to raise_error
  end

  it 'coerces values correctly' do
    subject.validate(title: 1)
    expect(subject.title).to eq('1')
  end

  it 'validates properties correctly' do
    subject.validate(title: nil)
    expect(subject).not_to be_valid
  end

  it 'coerces values in nested properties correctly' do
    subject.validate(title: 1, songs: [{ title: 2 }])
    expect(subject.songs.first.title).to eq('2')
  end
end
