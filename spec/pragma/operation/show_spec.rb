# frozen_string_literal: true
RSpec.describe Pragma::Operation::Show do
  subject(:context) do
    operation_klass.call(
      current_user: current_user,
      params: { id: 1 }
    )
  end

  let(:operation_klass) { API::V1::Post::Operation::Show }

  before do
    module API
      module V1
        module Post
          module Operation
            class Show < Pragma::Operation::Show
              def find_record
                OpenStruct.new(
                  title: 'Example Post 1',
                  author_id: 1
                )
              end
            end
          end

          class Policy < Pragma::Policy::Base
            def show?
              resource.author_id == user.id
            end
          end
        end
      end
    end
  end

  context 'when the user is authorized' do
    let(:current_user) { OpenStruct.new(id: 1) }

    it 'finds the record' do
      expect(context.resource.to_hash).to eq(
        'title' => 'Example Post 1'
      )
    end
  end

  context 'when the user is not authorized' do
    let(:current_user) { OpenStruct.new(id: 2) }

    it 'does not permit the retrieval' do
      expect(context.status).to eq(:forbidden)
    end
  end
end
