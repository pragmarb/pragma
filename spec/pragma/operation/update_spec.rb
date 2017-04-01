# frozen_string_literal: true
RSpec.describe Pragma::Operation::Update do
  subject(:context) do
    operation_klass.call(
      current_user: current_user,
      params: params
    )
  end

  let(:operation_klass) { API::V1::Post::Operation::Update }

  let(:params) do
    {
      id: 1,
      title: 'New Title'
    }
  end

  before do
    module API
      module V1
        module Post
          module Operation
            class Update < Pragma::Operation::Update
              def find_record
                OpenStruct.new(
                  title: 'Example Post 1',
                  author_id: 1
                )
              end
            end
          end

          module Contract
            class Update < Pragma::Contract::Base
              property :author_id
              property :title

              validation do
                required(:title).filled
              end
            end
          end

          class Policy < Pragma::Policy::Base
            def update?
              resource.author_id == user.id
            end
          end
        end
      end
    end
  end

  context 'when the user is authorized' do
    let(:current_user) { OpenStruct.new(id: 1) }

    it 'updates the record' do
      expect(context.resource.to_hash).to eq(
        'title' => 'New Title'
      )
    end

    context 'when invalid parameters are supplied' do
      let(:params) do
        {
          author_id: 1,
          title: ''
        }
      end

      it 'responds with 422 Unprocessable Entity' do
        expect(context.status).to eq(:unprocessable_entity)
      end
    end

  end

  context 'when the user is not authorized' do
    let(:current_user) { OpenStruct.new(id: 2) }

    it 'does not permit the update' do
      expect(context.status).to eq(:forbidden)
    end
  end
end
