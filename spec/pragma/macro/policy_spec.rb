# frozen_string_literal: true

RSpec.describe Pragma::Macro::Policy do
  subject(:result) do
    PolicyMacroTest::Operation.call(params, options)
  end

  let(:options) { { 'current_user' => current_user } }
  let(:params) { {} }

  context 'with the default action' do
    before do
      # rubocop:disable RSpec/InstanceVariable
      module PolicyMacroTest
        class Policy
          def initialize(user, model)
            @user = user
            @model = model
          end

          def operation?
            @user.id == @model.user_id
          end
        end

        class Operation < Pragma::Operation::Base
          self['policy.default.class'] = Policy

          step :model!
          step Pragma::Macro::Policy(), fail_fast: true
          step :finish!

          def model!(options)
            options['model'] = OpenStruct.new(user_id: 1)
          end

          def finish!(options)
            options['result.finished'] = true
          end
        end
      end
      # rubocop:enable RSpec/InstanceVariable
    end

    context 'when the user is authorized' do
      let(:current_user) { OpenStruct.new(id: 1) }

      it 'lets the operation continue' do
        expect(result['result.finished']).to be true
      end
    end

    context 'when the user is unauthorized' do
      let(:current_user) { OpenStruct.new(id: 2) }

      it 'stops the operation' do
        expect(result['result.finished']).not_to be true
      end

      it 'responds with 403 Forbidden' do
        expect(result['result.response'].status).to eq(403)
      end
    end
  end

  context 'when no policy is provided' do
    let(:current_user) { OpenStruct.new(id: 1) }

    before do
      module PolicyMacroTest
        class Operation < Pragma::Operation::Base
          self['policy.default.class'] = nil

          step :model!
          step Pragma::Macro::Policy(), fail_fast: true
          step :finish!

          def model!(options)
            options['model'] = OpenStruct.new(user_id: 1)
          end

          def finish!(options)
            options['result.finished'] = true
          end
        end
      end
    end

    it 'raises a MissingClassError' do
      expect { result }.to raise_error(Pragma::Macro::MissingSkillError)
    end
  end

  context 'with a custom action' do
    before do
      # rubocop:disable RSpec/InstanceVariable
      module PolicyMacroTest
        class Policy
          def initialize(user, model)
            @user = user
            @model = model
          end

          def custom_operation?
            @user.id == @model.user_id
          end
        end

        class Operation < Pragma::Operation::Base
          self['policy.default.class'] = Policy

          step :model!
          step Pragma::Macro::Policy(action: :custom_operation), fail_fast: true
          step :finish!

          def model!(options)
            options['model'] = OpenStruct.new(user_id: 1)
          end

          def finish!(options)
            options['result.finished'] = true
          end
        end
      end
      # rubocop:enable RSpec/InstanceVariable
    end

    context 'when the user is authorized' do
      let(:current_user) { OpenStruct.new(id: 1) }

      it 'lets the operation continue' do
        expect(result['result.finished']).to be true
      end
    end

    context 'when the user is unauthorized' do
      let(:current_user) { OpenStruct.new(id: 2) }

      it 'stops the operation' do
        expect(result['result.finished']).not_to be true
      end

      it 'responds with 403 Forbidden' do
        expect(result['result.response'].status).to eq(403)
      end
    end
  end
end
