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
            options["result.decorator.#{name}"] = options["decorator.#{name}.class"].represent(
              options['model'].respond_to?(:to_a) ? options['model'].to_a : options['model']
            )
          end
        end
      end
    end
  end
end
