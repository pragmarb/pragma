# frozen_string_literal: true
module Pragma
  module Operation
    module Macro
      def self.Pagination
        step = ->(input, options) { Pagination.for(input, options) }
        [step, name: 'paginate']
      end

      module Pagination
        DEFAULTS = {
          'pagination.page_param' => 'page',
          'pagination.per_page_param' => 'per_page',
          'pagination.default_per_page' => 30,
          'pagination.max_per_page' => 100
        }.freeze

        class << self
          def for(_input, options)
            DEFAULTS.each_pair do |key, value|
              options[key] = value unless options[key]
            end

            options['model'] = options['model'].paginate(
              page: page(options, **options),
              per_page: per_page(options, **options)
            )

            options['result.response'].headers = options['result.response'].headers.merge(
              'Page' => options['model'].current_page.to_i,
              'Per-Page' => options['model'].per_page,
              'Total' => options['model'].total_entries
            )
          end

          private

          def page(options, params:, **)
            return 1 if
              !params[options['pagination.page_param']] ||
              params[options['pagination.page_param']].empty?

            params[options['pagination.page_param']].to_i
          end

          def per_page(options, params:, **)
            return options['pagination.default_per_page'] if
              !params[options['pagination.per_page_param']] ||
              params[options['pagination.per_page_param']].empty?

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
