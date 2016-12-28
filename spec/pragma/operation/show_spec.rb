# frozen_string_literal: true
RSpec.describe Pragma::Operation::Show do
  let(:context) do
    operation_klass.call(
      current_user: current_user,
      params: { id: 1 }
    )
  end

  let(:operation_klass) do
    Class.new(described_class) do
      def find_record
        OpenStruct.new(
          title: 'Example Post 1',
          author_id: 1
        )
      end
    end.tap do |klass|
      allow(klass).to receive(:name).and_return('API::V1::Post::Operation::Show')
    end
  end

  let(:current_user) { nil }

  it 'finds the record' do
    expect(context.resource.to_h).to eq(
      title: 'Example Post 1',
      author_id: 1
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

    it 'decorates the resource' do
      expect(context.resource.to_hash).to eq(
        'title' => 'Example Post 1'
      )
    end
  end

  context 'when a policy is defined' do
    let(:policy_klass) do
      Class.new(Pragma::Policy::Base) do
        def show?
          resource.author_id == user.id
        end
      end
    end

    before do
      operation_klass.send(:policy, policy_klass)
    end

    context 'when the user is authorized' do
      let(:current_user) { OpenStruct.new(id: 1) }

      it 'permits the retrieval' do
        expect(context.resource.to_h).to eq(title: 'Example Post 1', author_id: 1)
      end
    end

    context 'when the user is authorized' do
      let(:current_user) { OpenStruct.new(id: 2) }

      it 'does not permit the retrievla' do
        expect(context.status).to eq(:forbidden)
      end
    end
  end
end
