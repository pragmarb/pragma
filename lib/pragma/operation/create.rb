# frozen_string_literal: true
module Pragma
  module Operation
    # Creates a new record and responds with the decorated record.
    #
    # @author Alessandro Desantis
    class Create < Pragma::Operation::Base
      step Macro::Classes()
      step :build!
      step Macro::Policy()
      step Contract::Build()
      step Contract::Validate()
      failure :failed_validation!
      step Contract::Persist()
      step Macro::Decorator()

      def build!(options)
        options['model'] = options['model.class'].new
      end

      def failed_validation!(options)
        options['result.response'] = Response::UnprocessableEntity.new(
          errors: options['contract.default'].errors
        )
      end
    end
  end
end
