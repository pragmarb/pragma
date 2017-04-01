# frozen_string_literal: true
RSpec.describe Pragma::Operation::Destroy do
  subject(:context) do
    operation_klass.call(
      current_user: current_user,
      params: { id: 1 }
    )
  end

  let(:operation_klass) { API::V1::Post::Operation::Destroy }

  before do
    module API
      module V1
        module Post
          module Operation
            class Destroy < Pragma::Operation::Destroy
              def find_record
                OpenStruct.new(
                  title: 'Example Post 1',
                  author_id: 1
                )
              end
            end
          end

          class Policy < Pragma::Policy::Base
            def destroy?
              resource.author_id == user.id
            end
          end
        end
      end
    end
  end

  context 'when the user is authorized' do
    let(:current_user) { OpenStruct.new(id: 1) }

    it 'responds with 204 No Content' do
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
