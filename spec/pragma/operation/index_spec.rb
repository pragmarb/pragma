# frozen_string_literal: true
RSpec.describe Pragma::Operation::Index do
  subject(:context) { operation_klass.call }

  let(:operation_klass) { API::V1::Post::Operation::Index }

  before do
    module API
      module V1
        module Post
          module Operation
            class Index < Pragma::Operation::Index
              def find_records
                [
                  OpenStruct.new(title: 'Example Post 1', author_id: 1),
                  OpenStruct.new(title: 'Example Post 2', author_id: 2)
                ]
              end
            end
          end

          class Policy < Pragma::Policy::Base
            def self.accessible_by(user:, scope:)
              scope.select do |post|
                post.author_id == 1
              end
            end
          end
        end
      end
    end
  end

  it 'finds all the records' do
    expect(context.resource.to_hash).to eq([
      { 'title' => 'Example Post 1' }
    ])
  end

  it 'includes pagination information in the headers' do
    expect(context.headers).to match(a_hash_including(
      'Page' => 1,
      'Per-Page' => 30,
      'Total' => 1
    ))
  end
end
