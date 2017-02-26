# frozen_string_literal: true
module Pragma
  module Operation
    module Macro
      def self.Decorator
        step = ->(input, options) { Decorator.for(input, options) }
        [step, name: 'decorate']
      end

      module Decorator
        class << self
          def for(_input, options)
            options['result.decorator'] = if options['decorator.default.class']
              options['decorator.default.class'].represent(options['model'])
            else
              options['model']
            end

            options['result.response'].entity = options['result.decorator']
          end
        end
      end
    end
  end
end
