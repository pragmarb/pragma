# frozen_string_literal: true
module Pragma
  module Operation
    # Finds all records of the requested resource, authorizes them, paginates them and decorates
    # them.
    #
    # @author Alessandro Desantis
    class Index < Pragma::Operation::Base
      step Macro::Classes()
      step :retrieve!
      step :scope!
      step Macro::Pagination()
      step Macro::Decorator()

      def retrieve!(options)
        options['model'] = options['model.class'].all
      end

      def scope!(options, current_user:, model:, **)
        options['model'] = options['policy.default.class'].accessible_by(
          user: current_user,
          scope: model
        )
      end
    end
  end
end
