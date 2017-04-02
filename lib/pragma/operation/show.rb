# frozen_string_literal: true
module Pragma
  module Operation
    # Finds the requested record, authorizes it and decorates it.
    #
    # @author Alessandro Desantis
    class Show < Pragma::Operation::Base
      step Macro::Classes()
      step Macro::Model()
      failure :handle_model_not_found!, fail_fast: true
      step Macro::Policy()
      failure :handle_unauthorized!, fail_fast: true
      step Macro::Decorator()

      def handle_model_not_found!(options)
        options['result.response'] = Response::NotFound.new
      end

      def handle_unauthorized!(options)
        options['result.response'] = Response::Forbidden.new
      end
    end
  end
end
