RSpec.describe Pragma::Operation::Index do
  let(:context) { operation_klass.call }

  let(:operation_klass) do
    Class.new(described_class).tap do |klass|
      allow(klass).to receive(:name).and_return('API::V1::Post::Operation::Index')
    end
  end

  before(:each) do
    class Post
      def self.all
        [
          OpenStruct.new(title: 'Example Post 1', author_id: 1),
          OpenStruct.new(title: 'Example Post 2', author_id: 2)
        ]
      end
    end
  end

  it 'finds all the records' do
    expect(context.resource.map(&:to_h)).to eq([
      { title: 'Example Post 1', author_id: 1 },
      { title: 'Example Post 2', author_id: 2 }
    ])
  end

  it 'includes pagination information in the headers' do
    expect(context.headers).to eq(
      'Page' => 1,
      'Per-Page' => 30,
      'Total' => 2
    )
  end

  context 'when a decorator is defined' do
    let(:decorator_klass) do
      Class.new(Pragma::Decorator::Base) do
        property :title
      end
    end

    before do
      operation_klass.send(:decorator, decorator_klass)
    end

    it 'decorates the records in the collection' do
      expect(context.resource.to_hash).to eq([
        { 'title' => 'Example Post 1' },
        { 'title' => 'Example Post 2' }
      ])
    end
  end

  context 'when a policy is defined' do
    let(:policy_klass) do
      Class.new(Pragma::Policy::Base) do
        def self.accessible_by(user:, scope:)
          scope.select do |post|
            post.author_id == 1
          end
        end
      end
    end

    before do
      operation_klass.send(:policy, policy_klass)
    end

    it 'scopes the accessible records' do
      expect(context.resource.map(&:to_h)).to eq([
        { title: 'Example Post 1', author_id: 1 }
      ])
    end
  end
end
