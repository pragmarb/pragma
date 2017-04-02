# frozen_string_literal: true
module Pragma
  module Operation
    module Macro
      def self.Decorator
        step = ->(input, options) { Decorator.for(input, options) }
        [step, name: 'decorator']
      end

      module Decorator
        class << self
          def for(_input, options)
            options['result.decorator.default'] = options['decorator.default.class'].represent(
              options['model']
            )

            options['result.response'].entity = options['result.decorator.default']
          end
        end
      end
    end
  end
end
