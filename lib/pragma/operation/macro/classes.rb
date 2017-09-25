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
              'decorator.instance.class' => expected_instance_decorator_class(input, options),
              'decorator.collection.class' => expected_collection_decorator_class(input, options),
              'contract.default.class' => expected_contract_class(input, options)
            }.each_pair do |key, value|
              next if options[key]

              # FIXME: This entire block is required to trigger Rails autoloading. Ugh.
              begin
                Object.const_get(value)
              rescue NameError => e
                # We check the error message to avoid silently ignoring other NameErrors
                # thrown while initializing the constant.
                if e.message.start_with?('uninitialized constant')
                  # Required instead of a simple equality check because loading
                  # API::V1::Post::Contract::Index might throw "uninitialized constant
                  # API::V1::Post::Contract" if the resource has no contracts at all.
                  error_constant = e.message.split.last
                  raise e unless value.sub(/\A::/, '').start_with?(error_constant)
                end
              end

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

          def expected_instance_decorator_class(input, options)
            [
              resource_namespace(input, options),
              'Decorator',
              'Instance'
            ].join('::')
          end

          def expected_collection_decorator_class(input, options)
            [
              resource_namespace(input, options),
              'Decorator',
              'Collection'
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
