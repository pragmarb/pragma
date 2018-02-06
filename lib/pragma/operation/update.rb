# frozen_string_literal: true

module Pragma
  module Operation
    # Finds an existing record, updates it and responds with the decorated record.
    #
    # @author Alessandro Desantis
    class Update < Pragma::Operation::Base
      step Macro::Classes()
      step Macro::Model(:find_by)
      step Macro::Policy()
      step Macro::Contract::Build()
      step Macro::Contract::Validate()
      step Macro::Contract::Persist()
      step Macro::Decorator()
      step :respond!, name: 'respond'

      def respond!(options)
        options['result.response'] = Response::Ok.new(entity: options['result.decorator.instance'])
      end
    end
  end
end
