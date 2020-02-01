# frozen_string_literal: true

RSpec.describe Pragma::Policy::Base do
  subject { policy_klass.new(user, record) }

  let(:policy_klass) do
    Class.new(described_class) do
      def show?
        user.id == record.author_id
      end
    end
  end

  let(:user) { OpenStruct.new(id: 1) }
  let(:record) { OpenStruct.new(author_id: 1) }

  describe 'predicate methods' do
    context 'when the user is authorized' do
      let(:user) { OpenStruct.new(id: 1) }

      it 'return true' do
        expect(subject.show?).to be true
      end
    end

    context 'when the user is not authorized' do
      let(:user) { OpenStruct.new(id: 2) }

      it 'return false' do
        expect(subject.show?).to be false
      end
    end
  end

  describe 'bang methods' do
    context 'when the user is authorized' do
      let(:user) { OpenStruct.new(id: 1) }

      it 'does not raise errors' do
        expect { subject.show! }.not_to raise_error
      end
    end

    context 'when the user is not authorized' do
      let(:user) { OpenStruct.new(id: 2) }

      it 'raises a NotAuthorizedError' do
        expect { subject.show! }.to raise_error(Pragma::Policy::NotAuthorizedError)
      end
    end
  end
end
