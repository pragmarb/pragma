# frozen_string_literal: true

module Pragma
  module Operation
    # Creates a new record and responds with the decorated record.
    #
    # @author Alessandro Desantis
    class Create < Pragma::Operation::Base
      step Macro::Classes()
      step Macro::Model()
      step Macro::Policy()
      step Macro::Contract::Build()
      step Macro::Contract::Validate()
      step Macro::Contract::Persist()
      step Macro::Decorator()
      step :respond!, name: 'respond'

      def respond!(options)
        options['result.response'] = Response::Created.new(
          entity: options['result.decorator.instance']
        )
      end
    end
  end
end
