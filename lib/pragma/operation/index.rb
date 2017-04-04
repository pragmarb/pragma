# frozen_string_literal: true

require 'trailblazer/dsl'

module Pragma
  module Operation
    # Finds all records of the requested resource, authorizes them, paginates them and decorates
    # them.
    #
    # @author Alessandro Desantis
    class Index < Pragma::Operation::Base
      extend Trailblazer::Operation::Contract::DSL

      contract 'pagination', (Dry::Validation.Schema do
        # FIXME: We need to use the parameter names specified in `options` here.
        # TODO: We need to validate that page isn't greater than the number of retrieved pages.
        # TODO: We need to validate that per_page isn't greater than the upper limit in `options`.
        optional(:page).maybe { int? > gteq?(1) }
        optional(:per_page).maybe { int? > gteq?(1) }

        # This doesn't work because 1) we don't have access to `options` here, and 2) because these
        # options are not even defined at this point. The only potential fix I see right now is to
        # move the entire schema building to a step.
        # optional(options['pagination.page_param']).maybe { int? > gteq?(1) > lteq?(options['model'].total_pages) }
        # optional(options['pagination.per_page_param']).maybe { int? > gteq?(1) > lteq?(options['pagination.max_per_page']) }
      end)

      step Macro::Contract::Validate(name: 'pagination')
      failure :handle_invalid_pagination_contract!, fail_fast: true
      step Macro::Classes()
      step :retrieve!
      step :scope!
      step Macro::Pagination()
      step Macro::Decorator()
      step :respond!

      def handle_invalid_pagination_contract!(options)
        options['result.response'] = Response::UnprocessableEntity.new(
          errors: options['result.contract.pagination'].errors
        ).decorate_with(Decorator::Error)
      end

      def retrieve!(options)
        options['model'] = options['model.class'].all
      end

      def scope!(options, current_user:, model:, **)
        options['model'] = options['policy.default.scope.class'].new(current_user, model).resolve
      end

      def respond!(options, model:, **)
        options['result.response'] = Response::Ok.new(
          entity: options['result.decorator.default'],
          headers: {
            'Page' => model.current_page.to_i,
            'Per-Page' => model.per_page,
            'Total' => model.total_entries
          }
        )
      end
    end
  end
end
