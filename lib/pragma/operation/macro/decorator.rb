# frozen_string_literal: true

module Pragma
  module Operation
    module Macro
      def self.Decorator(name: :default)
        step = ->(input, options) { Decorator.for(input, name, options) }
        [step, name: "decorator.#{name}"]
      end

      module Decorator
        class << self
          def for(_input, name, options)
            unless validate_params(options)
              handle_invalid_contract(options)
              return false
            end

            options["result.decorator.#{name}"] = options["decorator.#{name}.class"].represent(
              options['model'].respond_to?(:to_a) ? options['model'].to_a : options['model']
            )
          end

          private

          def validate_params(options)
            options['contract.expand'] = Dry::Validation.Schema do
              optional(:expand).each(:str?)
            end

            options['result.contract.expand'] = options['contract.expand'].call(options['params'])

            options['result.contract.expand'].errors.empty?
          end

          def handle_invalid_contract(options)
            options['result.response'] = Response::UnprocessableEntity.new(
              errors: options['result.contract.expand'].errors
            ).decorate_with(Pragma::Decorator::Error)
          end
        end
      end
    end
  end
end
