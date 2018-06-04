# frozen_string_literal: true

module Pragma
  module Operation
    # Finds all records of the requested resource, authorizes them, paginates them and decorates
    # them.
    #
    # @author Alessandro Desantis
    class Index < Pragma::Operation::Base
      step Macro::Classes()
      step :retrieve!, name: 'retrieve'
      step :scope!, name: 'scope'
      step Macro::Filtering()
      step Macro::Ordering()
      step Macro::Pagination()
      step Macro::Decorator(name: :collection)
      step :respond!, name: 'respond'

      def retrieve!(options)
        options['model'] = options['model.class'].all
      end

      # TODO: Turn this into a macro.
      def scope!(options, model:, **)
        options['model'] = options['policy.default.scope.class'].new(
          options['policy.context'] || options['current_user'],
          model
        ).resolve
      end

      def respond!(options, **)
        options['result.response'] = Response::Ok.new(
          entity: options['result.decorator.collection']
        )
      end
    end
  end
end
