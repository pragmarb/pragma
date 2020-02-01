# frozen_string_literal: true

RSpec.describe Pragma::Resource::Macro::Classes do
  SETUP_CODE = <<~RUBY
    class Article; end

    module API
      module V1
        module Article
          module Operation
            class Create < Pragma::Operation::Base
              step Pragma::Resource::Macro::Classes()
              class AsAdmin < Create; end
            end
          end

          class Policy
            class Scope; end
          end

          module Decorator
            class Instance; end
            class Collection; end
          end

          module Contract
            class Create
              class AsAdmin; end
            end
          end
        end
      end
    end
  RUBY

  class << self
    def validate_classes(operation, expectations)
      expectations.each do |key, expected|
        it "computes #{key} correctly" do
          expect(Object.const_get(operation).call[key].to_s).to eq(expected)
        end
      end
    end
  end

  before do
    # rubocop:disable Security/Eval, Style/EvalWithLocation
    eval <<~RUBY
      #{SETUP_CODE}

      module Blog
        #{SETUP_CODE}
      end
    RUBY
    # rubocop:enable Security/Eval, Style/EvalWithLocation
  end

  # rubocop:disable RSpec/EmptyExampleGroup
  context 'with a root operation' do
    validate_classes(
      'API::V1::Article::Operation::Create',
      'model.class' => 'Article',
      'policy.default.class' => 'API::V1::Article::Policy',
      'policy.default.scope.class' => 'API::V1::Article::Policy::Scope',
      'contract.default.class' => 'API::V1::Article::Contract::Create',
      'decorator.instance.class' => 'API::V1::Article::Decorator::Instance',
      'decorator.collection.class' => 'API::V1::Article::Decorator::Collection'
    )
  end

  context 'with a nested operation' do
    validate_classes(
      'API::V1::Article::Operation::Create::AsAdmin',
      'model.class' => 'Article',
      'policy.default.class' => 'API::V1::Article::Policy',
      'policy.default.scope.class' => 'API::V1::Article::Policy::Scope',
      'contract.default.class' => 'API::V1::Article::Contract::Create::AsAdmin',
      'decorator.instance.class' => 'API::V1::Article::Decorator::Instance',
      'decorator.collection.class' => 'API::V1::Article::Decorator::Collection'
    )
  end

  context 'with an engine and a root operation' do
    validate_classes(
      'Blog::API::V1::Article::Operation::Create',
      'model.class' => 'Blog::Article',
      'policy.default.class' => 'Blog::API::V1::Article::Policy',
      'policy.default.scope.class' => 'Blog::API::V1::Article::Policy::Scope',
      'contract.default.class' => 'Blog::API::V1::Article::Contract::Create',
      'decorator.instance.class' => 'Blog::API::V1::Article::Decorator::Instance',
      'decorator.collection.class' => 'Blog::API::V1::Article::Decorator::Collection'
    )
  end

  context 'with an engine and a nested operation' do
    validate_classes(
      'Blog::API::V1::Article::Operation::Create::AsAdmin',
      'model.class' => 'Blog::Article',
      'policy.default.class' => 'Blog::API::V1::Article::Policy',
      'policy.default.scope.class' => 'Blog::API::V1::Article::Policy::Scope',
      'contract.default.class' => 'Blog::API::V1::Article::Contract::Create::AsAdmin',
      'decorator.instance.class' => 'Blog::API::V1::Article::Decorator::Instance',
      'decorator.collection.class' => 'Blog::API::V1::Article::Decorator::Collection'
    )
  end
  # rubocop:enable RSpec/EmptyExampleGroup
end
