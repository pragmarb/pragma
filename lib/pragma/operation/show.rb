# frozen_string_literal: true
module Pragma
  module Operation
    # Finds the requested record, authorizes it and decorates it.
    #
    # @author Alessandro Desantis
    class Show < Pragma::Operation::Base
      step Macro::Classes()
      step :retrieve!
      failure :not_found!
      step Macro::Policy()
      step Macro::Decorator()

      def retrieve!(options, params:, **)
        options['model'] = options['model.class'].find(params['id'])
      end

      def not_found!(options)
        # TODO: handle
      end
    end
  end
end
