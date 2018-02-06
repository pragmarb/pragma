# frozen_string_literal: true

RSpec.describe Pragma::Macro::Decorator do
  subject(:result) do
    DecoratorMacroTest::Operation.call(
      params,
      options.merge('decorator.instance.class' => decorator)
    )
  end

  let(:options) { {} }
  let(:params) { {} }
  let(:decorator) { DecoratorMacroTest::InstanceDecorator }

  before do
    module DecoratorMacroTest
      class InstanceDecorator
        attr_reader :model

        def initialize(model)
          @model = model
        end
      end

      class FailingInstanceDecorator < InstanceDecorator
        def validate_expansion(*)
          fail Pragma::Decorator::Association::ExpansionError, 'test'
        end
      end

      class Operation < Pragma::Operation::Base
        self['expand.limit'] = 3

        step :model!
        step Pragma::Macro::Decorator(name: :instance)

        def model!(_options)
          self['model'] = OpenStruct.new(id: 1)
        end
      end
    end
  end

  it 'decorates the model' do
    expect(result['result.decorator.instance'].model.id).to eq(1)
  end

  context 'when the decorator fails expansion' do
    let(:decorator) { DecoratorMacroTest::FailingInstanceDecorator }

    it 'responds with 400 Bad Request' do
      expect(result['result.response'].status).to eq(400)
    end

    it 'responds with an error message' do
      expect(result['result.response'].entity).to be_instance_of(Pragma::Decorator::Error)
    end
  end

  context 'when the expand parameter is not an array' do
    let(:params) do
      {
        expand: { 'foo' => 'bar' }
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end

    it 'responds with an error message' do
      expect(result['result.response'].entity).to be_instance_of(Pragma::Decorator::Error)
    end
  end

  context 'when the expand parameter is not an array of strings' do
    let(:params) do
      {
        expand: [1, 2, 3]
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end

    it 'responds with an error message' do
      expect(result['result.response'].entity).to be_instance_of(Pragma::Decorator::Error)
    end
  end

  context 'when too many associations are expanded' do
    let(:params) do
      {
        expand: %w[user customer invoice company]
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end

    it 'responds with an error message' do
      expect(result['result.response'].entity).to be_instance_of(Pragma::Decorator::Error)
    end
  end

  context 'when expansion is disabled and we want to expand' do
    let(:options) do
      { 'expand.enabled' => false }
    end

    let(:params) do
      {
        expand: ['user']
      }
    end

    it 'responds with 422 Unprocessable Entity' do
      expect(result['result.response'].status).to eq(422)
    end

    it 'responds with an error message' do
      expect(result['result.response'].entity).to be_instance_of(Pragma::Decorator::Error)
    end
  end
end
