# frozen_string_literal: true
module Pragma
  module Operation
    # Finds the requested record, authorizes it and decorates it.
    #
    # @author Alessandro Desantis
    class Show < Pragma::Operation::Base
      step Macro::Classes()
      step :retrieve!
      step :authorize!
      failure! :handle_unauthorized!
      step Macro::Decorator()

      def retrieve!(options)
        options['model'] = options['model.class'].find(params[:id])
      end

      def authorize!(options)
        true # TODO: implement
      end

      def handle_unauthorized!(options)
        true # TODO: implement
      end
    end
  end
end
