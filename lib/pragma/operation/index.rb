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
      step :respond!

      def retrieve!(options)
        options['model'] = options['model.class'].all
      end

      def scope!(options, current_user:, model:, **)
        options['model'] = options['policy.default.scope.class'].new(current_user, model).resolve
      end

      def respond!(options)
        options['result.response'] = Response::Ok.new(
          entity: options['result.decorator.default'],
          headers: {
            'Page' => options['model'].current_page.to_i,
            'Per-Page' => options['model'].per_page,
            'Total' => options['model'].total_entries
          }
        )
      end
    end
  end
end
