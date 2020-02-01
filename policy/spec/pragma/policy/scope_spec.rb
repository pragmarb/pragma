# frozen_string_literal: true

RSpec.describe Pragma::Policy::Scope do
  subject { scope_klass.new(user, articles) }

  let(:user) { OpenStruct.new(id: 1) }
  let(:articles) { [OpenStruct.new(id: 1, author_id: 1), OpenStruct.new(id: 1, author_id: 2)] }

  let(:scope_klass) do
    Class.new(Pragma::Policy::Scope) do
      def resolve
        scope.select do |article|
          article.author_id == user.id
        end
      end
    end
  end

  describe '#resolve' do
    it 'returns the records accessible by the user' do
      expect(subject.resolve.map(&:id)).to eq([1])
    end
  end
end
