# frozen_string_literal: true

RSpec.describe Pragma::Decorator::Timestamp do
  subject { decorator_klass.new(model) }

  let(:decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      include Pragma::Decorator::Timestamp
      timestamp :created_at
    end
  end

  let(:model) { OpenStruct.new(created_at: Time.utc(1970, 'jan', 1, 1, 0, 0)) }

  let(:result) { JSON.parse(subject.to_json) }

  it 'converts the timestamp to UNIX time' do
    expect(result).to include('created_at' => 3600)
  end

  context 'with the :as option' do
    let(:decorator_klass) do
      Class.new(Pragma::Decorator::Base) do
        include Pragma::Decorator::Timestamp
        timestamp :creation_time, as: :created_at
      end
    end

    let(:model) { OpenStruct.new(creation_time: Time.utc(1970, 'jan', 1, 1, 0, 0)) }

    it 'computes the timestamp from a different property' do
      expect(result).to include('created_at' => 3600)
    end
  end
end
