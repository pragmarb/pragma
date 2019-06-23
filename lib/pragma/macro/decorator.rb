# frozen_string_literal: true

module Pragma
  module Macro
    def self.Decorator(name: :instance)
      step = ->(input, options) { Decorator.for(input, name, options) }
      [step, name: "decorator.#{name}"]
    end

    module Decorator
      class << self
        def for(_input, name, options)
          klass = Macro.require_skill('Decorator', "decorator.#{name}.class", options)

          set_defaults(options)

          return false unless validate_params(options)

          options["result.decorator.#{name}"] = klass.new(options['model'])

          validate_expansion(options, name)
        end

        private

        def set_defaults(options)
          hash_options = options.to_hash

          {
            'expand.enabled' => true
          }.each_pair do |key, value|
            options[key] = value unless hash_options.key?(key.to_sym)
          end
        end

        def validate_params(options)
          options['contract.expand'] = Dry::Validation.Schema do
            optional(:expand) do
              if options['expand.enabled']
                array? do
                  each(:str?) &
                    # This is the ugliest, only way I found to define a dynamic validation tree.
                    (options['expand.limit'] ? max_size?(options['expand.limit']) : array?)
                end
              else
                none? | empty?
              end
            end
          end

          options['result.contract.expand'] = options['contract.expand'].call(options['params'])

          if options['result.contract.expand'].errors.any?
            options['result.response'] = Operation::Response::UnprocessableEntity.new(
              errors: options['result.contract.expand'].errors
            ).decorate_with(Pragma::Decorator::Error)

            return false
          end

          true
        end

        def validate_expansion(options, name)
          return true unless options["result.decorator.#{name}"].respond_to?(:validate_expansion)

          options["result.decorator.#{name}"].validate_expansion(options['params'][:expand])
          true
        rescue Pragma::Decorator::Association::ExpansionError => e
          options['result.response'] = Operation::Response::BadRequest.new(
            entity: Pragma::Operation::Error.new(
              error_type: :expansion_error,
              error_message: e.message
            )
          ).decorate_with(Pragma::Decorator::Error)
          false
        end
      end
    end
  end
end
