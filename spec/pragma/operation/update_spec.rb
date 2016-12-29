# frozen_string_literal: true
RSpec.describe Pragma::Operation::Update do
  let(:context) do
    operation_klass.call(
      current_user: current_user,
      params: { id: 1, title: 'New Title' }
    )
  end

  let(:contract_klass) do
    Class.new(Pragma::Contract::Base) do
      property :author_id
      property :title

      validation do
        required(:title).filled
      end
    end
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
      klass.send(:contract, contract_klass)
      allow(klass).to receive(:name).and_return('API::V1::Post::Operation::Update')
    end
  end

  let(:current_user) { nil }

  it 'updates the record' do
    expect(context.resource.to_h).to eq(
      title: 'New Title',
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

    it 'decorates the updated resource' do
      expect(context.resource.to_hash).to eq(
        'title' => 'New Title'
      )
    end
  end

  context 'when a policy is defined' do
    let(:policy_klass) do
      Class.new(Pragma::Policy::Base) do
        def update?
          resource.author_id == user.id
        end
      end
    end

    before do
      operation_klass.send(:policy, policy_klass)
    end

    context 'when the user is authorized' do
      let(:current_user) { OpenStruct.new(id: 1) }

      it 'permits the update' do
        expect(context.resource.to_h).to eq(title: 'New Title', author_id: 1)
      end
    end

    context 'when the user is authorized' do
      let(:current_user) { OpenStruct.new(id: 2) }

      it 'does not permit the update' do
        expect(context.status).to eq(:forbidden)
      end
    end
  end
end
