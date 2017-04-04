# frozen_string_literal: true

module Pragma
  module Operation
    module Macro
      def self.Pagination
        step = ->(input, options) { Pagination.for(input, options) }
        [step, name: 'pagination']
      end

      module Pagination
        class << self
          def for(_input, options)
            options['model'] = options['model'].paginate(
              page: page(options, **options),
              per_page: per_page(options, **options)
            )
          end

          private

          def page(options, params:, **)
            return 1 if
              !params[options['pagination.page_param']] ||
              params[options['pagination.page_param']].blank?

            params[options['pagination.page_param']].to_i
          end

          def per_page(options, params:, **)
            return options['pagination.default_per_page'] if
              !params[options['pagination.per_page_param']] ||
              params[options['pagination.per_page_param']].blank?

            [
              params[options['pagination.per_page_param']].to_i,
              options['pagination.max_per_page']
            ].min
          end
        end
      end
    end
  end
end
