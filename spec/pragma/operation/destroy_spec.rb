# frozen_string_literal: true
RSpec.describe Pragma::Operation::Destroy do
  subject(:context) do
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
      allow(klass).to receive(:name).and_return('API::V1::Post::Operation::Destroy')
    end
  end

  let(:current_user) { nil }

  it 'responds with 204 No Content' do
    expect(context.status).to eq(:no_content)
  end

  context 'when a policy is defined' do
    let(:policy_klass) do
      Class.new(Pragma::Policy::Base) do
        def destroy?
          resource.author_id == user.id
        end
      end
    end

    before do
      operation_klass.send(:policy, policy_klass)
    end

    context 'when the user is authorized' do
      let(:current_user) { OpenStruct.new(id: 1) }

      it 'permits the destruction' do
        expect(context.status).to eq(:no_content)
      end
    end

    context 'when the user is not authorized' do
      let(:current_user) { OpenStruct.new(id: 2) }

      it 'does not permit the destruction' do
        expect(context.status).to eq(:forbidden)
      end
    end
  end
end
