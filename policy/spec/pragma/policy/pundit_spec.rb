# frozen_string_literal: true

RSpec.describe Pragma::Policy::Pundit do
  subject { TestPragmaPolicy.new(user, record) }

  before do
    class TestPunditPolicy
      class Scope
        attr_reader :user, :scope

        def initialize(user, scope)
          @user = user
          @scope = scope
        end

        def resolve
          scope.select do |article|
            article.author_id == user.id
          end
        end
      end

      attr_reader :user, :record

      def initialize(user, record)
        @user = user
        @record = record
      end

      def show?
        user.id == record.author_id
      end

      def create?
        user.author?
      end
    end

    class TestPragmaPolicy < Pragma::Policy::Pundit
      self.pundit_klass = TestPunditPolicy

      def create?
        user.admin?
      end
    end
  end

  let(:user) { OpenStruct.new(id: 1, author?: true, admin?: false) }
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

    it 'can be overridden' do
      expect(subject.create?).to be false
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

  describe 'scope' do
    subject { TestPragmaPolicy::Scope.new(user, articles) }

    let(:articles) { [OpenStruct.new(id: 1, author_id: 1), OpenStruct.new(id: 2, author_id: 2)] }

    it 'delegates to the Pundit scope' do
      expect(subject.resolve.map(&:id)).to eq([1])
    end
  end
end
