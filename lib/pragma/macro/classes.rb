# frozen_string_literal: true

module Pragma
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
              raise e unless e.message.start_with?('uninitialized constant')

              # Required instead of a simple equality check because loading
              # API::V1::Post::Contract::Index might throw "uninitialized constant
              # API::V1::Post::Contract" if the resource has no contracts at all.
              error_constant = e.message.scan(/uninitialized constant ([^\s]+)/).first.first
              raise e unless value.sub(/\A::/, '').start_with?(error_constant)
            end

            options[key] = (Object.const_get(value) if Object.const_defined?(value))
          end
        end

        private

        def resource_namespace(input, _options)
          parts = input.class.name.split('::')
          parts[0..(parts.index('Operation') - 1)]
        end

        def root_namespace(input, options)
          resource_namespace = resource_namespace(input, options)
          return [] if resource_namespace.first.casecmp('API').zero?
          api_index = (resource_namespace.map(&:upcase).index('API') || 1)
          resource_namespace[0..(api_index - 1)]
        end

        def expected_model_class(input, options)
          [
            root_namespace(input, options).join('::'),
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
          parts = input.class.name.split('::')

          [
            resource_namespace(input, options),
            'Contract',
            parts[(parts.index('Operation') + 1)..-1]
          ].join('::')
        end
      end
    end
  end
end
