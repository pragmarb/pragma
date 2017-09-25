# frozen_string_literal: true

require 'trailblazer/dsl'

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
      step Macro::Pagination(), fail_fast: true
      step Macro::Decorator(name: :collection), fail_fast: true
      step :respond!

      def retrieve!(options)
        options['model'] = options['model.class'].all
      end

      def scope!(options, current_user:, model:, **)
        options['model'] = options['policy.default.scope.class'].new(current_user, model).resolve
      end

      def respond!(options, model:, **)
        options['result.response'] = Response::Ok.new(
          entity: options['result.decorator.collection']
        )
      end
    end
  end
end
