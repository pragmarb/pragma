# frozen_string_literal: true

module Pragma
  module Operation
    # Finds the requested record, authorizes it and decorates it.
    #
    # @author Alessandro Desantis
    class Show < Pragma::Operation::Base
      step Macro::Classes()
      step Macro::Model(:find_by)
      step Macro::Policy()
      step Macro::Decorator()
      step :respond!

      def respond!(options)
        options['result.response'] = Response::Ok.new(entity: options['result.decorator.instance'])
      end
    end
  end
end
