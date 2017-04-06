# frozen_string_literal: true

require 'trailblazer/dsl'

module Pragma
  module Operation
    # Finds all records of the requested resource, authorizes them, paginates them and decorates
    # them.
    #
    # @author Alessandro Desantis
    class Index < Pragma::Operation::Base
      self['pagination.page_param'] = :page
      self['pagination.per_page_param'] = :per_page
      self['pagination.default_per_page'] = 30
      self['pagination.max_per_page'] = 100

      step Macro::Classes()
      # FIXME: A lot of duplication here...
      step :validate_pagination_params!
      failure :handle_invalid_pagination_contract!, fail_fast: true
      step :validate_expand_param!
      failure :handle_invalid_expand_contract!, fail_fast: true
      step :retrieve!
      step :scope!
      step Macro::Pagination()
      step Macro::Decorator()
      step :respond!

      def validate_pagination_params!(options, params:, **)
        options['contract.pagination'] = Dry::Validation.Schema do
          optional(options['pagination.page_param']).filled { int? > gteq?(1) }
          optional(options['pagination.per_page_param']).filled { int? > (gteq?(1) & lteq?(options['pagination.max_per_page'])) }
        end

        options['result.contract.pagination'] = options['contract.pagination'].call(params)

        options['result.contract.pagination'].errors.empty?
      end

      def handle_invalid_pagination_contract!(options)
        options['result.response'] = Response::UnprocessableEntity.new(
          errors: options['result.contract.pagination'].errors
        ).decorate_with(Decorator::Error)
      end

      def validate_expand_param!(options, params:, **)
        options['contract.expand'] = Dry::Validation.Schema do
          optional(:expand).each(:str?)
        end

        options['result.contract.expand'] = options['contract.expand'].call(params)

        options['result.contract.expand'].errors.empty?
      end

      def handle_invalid_expand_contract!(options)
        options['result.response'] = Response::UnprocessableEntity.new(
          errors: options['result.contract.expand'].errors
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
