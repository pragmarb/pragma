# frozen_string_literal: true

module Pragma
  module Operation
    # Creates a new record and responds with the decorated record.
    #
    # @author Alessandro Desantis
    class Create < Pragma::Operation::Base
      step Macro::Classes()
      step Macro::Model()
      step Macro::Policy(), fail_fast: true
      step Macro::Contract::Build()
      step Macro::Contract::Validate(), fail_fast: true
      step Macro::Contract::Persist(), fail_fast: true
      step Macro::Decorator()
      step :respond!

      def respond!(options)
        options['result.response'] = Response::Created.new(
          entity: options['result.decorator.default']
        )
      end
    end
  end
end
