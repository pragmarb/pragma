# frozen_string_literal: true

module Pragma
  module Operation
    module Macro
      def self.Classes
        step = ->(input, options) { Classes.for(input, options) }
        [step, name: 'classes']
      end

      module Classes
        class << self
          def for(input, options)
            {
              'model.class' => expected_model_class(input, options),
              'policy.default.class' => expected_policy_class(input, options),
              'policy.default.scope.class' => expected_policy_scope_class(input, options),
              'decorator.default.class' => expected_decorator_class(input, options),
              'contract.default.class' => expected_contract_class(input, options)
            }.each_pair do |key, value|
              next if options[key]
              options[key] = if Object.const_defined?(value)
                Object.const_get(value)
              end
            end
          end

          private

          def resource_namespace(input, _options)
            input.class.name.split('::')[0..-3]
          end

          def expected_model_class(input, options)
            [
              nil,
              resource_namespace(input, options).last
            ].join('::')
          end

          def expected_policy_class(input, options)
            [
              resource_namespace(input, options),
              'Policy'
            ].join('::')
          end

          def expected_policy_scope_class(input, options)
            "#{expected_policy_class(input, options)}::Scope"
          end

          def expected_decorator_class(input, options)
            [
              resource_namespace(input, options),
              'Decorator'
            ].join('::')
          end

          def expected_contract_class(input, options)
            [
              resource_namespace(input, options),
              'Contract',
              input.class.name.split('::').last
            ].join('::')
          end
        end
      end
    end
  end
end
