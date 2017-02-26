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

            options['model'] = model.paginate(
              page: page(options, params: params),
              per_page: per_page(options, params: params)
            )

            options['result.headers'] = (options['result.headers'] || {}).merge(
              'Page' => model.current_page.to_i,
              'Per-Page' => model.per_page,
              'Total' => model.total_entries
            )
          end
        end
      end
    end
  end
end
