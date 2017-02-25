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
      step :authorize!
      step Macro::Pagination()
      step Macro::Decorator()

      def retrieve!(options)
        options['model'] = options['model.class'].all
      end

      def authorize!(options, current_user:, model:)
        options['model'] = options['policy.default.class'].accessible_by(
          user: current_user,
          scope: model
        )
      end

      private

      def page(options, params:, **)
        return 1 if (
          !params[options['pagination.page_param']] ||
          params[options['pagination.page_param']].empty?
        )

        params[options['pagination.page_param']].to_i
      end

      def per_page(options, params:, **)
        return options['pagination.default_per_page'] if (
          !params[options['pagination.per_page_param']] ||
          params[options['pagination.per_page_param']].empty?
        )

        [
          params[options['pagination.per_page_param']].to_i,
          options['pagination.max_per_page']
        ].min
      end
    end
  end
end
