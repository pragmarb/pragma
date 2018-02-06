# frozen_string_literal: true

RSpec.describe Pragma::Macro::Model do
  subject(:result) do
    operation_class.call(params, options)
  end

  let(:options) { {} }
  let(:params) { {} }

  before do
    module ModelMacroTest
      class Model
        def self.find_by(id:)
          OpenStruct.new if id == 1
        end
      end

      class BuildingOperation < Pragma::Operation::Base
        self['model.class'] = ModelMacroTest::Model
        step Pragma::Macro::Model()
      end

      class FindingOperation < Pragma::Operation::Base
        self['model.class'] = ModelMacroTest::Model
        step Pragma::Macro::Model(:find_by)
      end
    end
  end

  describe 'building a record' do
    let(:operation_class) { ModelMacroTest::BuildingOperation }

    it 'builds the record' do
      expect(result['model']).to be_instance_of(ModelMacroTest::Model)
    end
  end

  describe 'finding a record' do
    let(:operation_class) { ModelMacroTest::FindingOperation }

    context 'when the record is found' do
      let(:params) do
        { id: 1 }
      end

      it 'sets the model in the result' do
        expect(result['model']).to be_instance_of(OpenStruct)
      end
    end

    context 'when the record is not found' do
      let(:params) do
        { id: 2 }
      end

      it 'responds with 404 Not Found' do
        expect(result['result.response'].status).to eq(404)
      end
    end
  end
end
