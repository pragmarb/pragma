# frozen_string_literal: true
RSpec.describe Pragma::Operation::Create do
  subject(:context) do
    operation_klass.call(
      current_user: current_user,
      params: params
    )
  end

  let(:operation_klass) { API::V1::Post::Operation::Create }

  let(:params) do
    {
      author_id: 1,
      title: 'My Post'
    }
  end

  before(:each) do
    module API
      module V1
        module Post
          module Operation
            class Create < Pragma::Operation::Create
              def build_record
                OpenStruct.new
              end
            end
          end

          module Contract
            class Create < Pragma::Contract::Base
              property :author_id
              property :title

              validation do
                required(:title).filled
              end
            end
          end

          class Policy < Pragma::Policy::Base
            def create?
              resource.author_id == user.id
            end
          end
        end
      end
    end
  end

  context 'when the user is authorized' do
    let(:current_user) { OpenStruct.new(id: 1) }

    it 'creates the record' do
      expect(context.resource.to_hash).to eq(
        'title' => 'My Post'
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

    it 'does not permit the creation' do
      expect(context.status).to eq(:forbidden)
    end
  end
end
