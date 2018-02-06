# frozen_string_literal: true

RSpec.describe Pragma::Macro::Classes do
  subject(:result) { ClassesMacroTest::API::V1::Article::Operation::ClassesMacroTest.call }

  before do
    module ClassesMacroTest
      class Article; end

      module API
        module V1
          module Article
            module Operation
              class ClassesMacroTest < Pragma::Operation::Base
                step Pragma::Macro::Classes()
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
              class ClassesMacroTest; end
            end
          end
        end
      end
    end
  end

  it 'sets the model class' do
    expect(result['model.class']).to eq(ClassesMacroTest::Article)
  end

  it 'sets the policy class' do
    expect(result['policy.default.class']).to eq(ClassesMacroTest::API::V1::Article::Policy)
  end

  it 'sets the policy scope class' do
    expect(result['policy.default.scope.class']).to eq(
      ClassesMacroTest::API::V1::Article::Policy::Scope
    )
  end

  it 'sets the contract class' do
    expect(result['contract.default.class']).to eq(
      ClassesMacroTest::API::V1::Article::Contract::ClassesMacroTest
    )
  end

  it 'sets the instance decorator class' do
    expect(result['decorator.instance.class']).to eq(
      ClassesMacroTest::API::V1::Article::Decorator::Instance
    )
  end

  it 'sets the collection decorator class' do
    expect(result['decorator.collection.class']).to eq(
      ClassesMacroTest::API::V1::Article::Decorator::Collection
    )
  end
end
