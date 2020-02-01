# frozen_string_literal: true

RSpec.describe Pragma::Operation::Response do
  subject { described_class.new }

  it 'has a 200 status by default' do
    expect(subject.status).to eq(200)
  end

  {
    '1' => true,
    '2' => true,
    '3' => true,
    '4' => false,
    '5' => false
  }.each_pair do |digit, expected_result|
    context "when the status is #{digit}xx" do
      subject { described_class.new(status: "#{digit}00".to_i) }

      describe '#success?' do
        it "returns #{expected_result}" do
          expect(subject.success?).to eq(expected_result)
        end
      end

      describe '#failure?' do
        it "returns #{!expected_result}" do
          expect(subject.failure?).to eq(!expected_result)
        end
      end
    end
  end

  describe '#status=' do
    context 'when the status is an integer' do
      it 'fails with an invalid status' do
        expect {
          subject.status = 600
        }.to raise_error(ArgumentError)
      end

      it 'sets a valid status' do
        expect {
          subject.status = 400
        }.to change(subject, :status).to(400)
      end
    end

    context 'when the status is a symbol' do
      it 'fails with an invalid status' do
        expect {
          subject.status = :invalid
        }.to raise_error(ArgumentError)
      end

      it 'sets a valid status' do
        expect {
          subject.status = :bad_request
        }.to change(subject, :status).to(400)
      end
    end

    context 'when the status is a string' do
      it 'fails with an invalid status' do
        expect {
          subject.status = 'invalid'
        }.to raise_error(ArgumentError)
      end

      it 'sets a valid status' do
        expect {
          subject.status = 'bad_request'
        }.to change(subject, :status).to(400)
      end
    end
  end
end
