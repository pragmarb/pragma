# frozen_string_literal: true

module Pragma
  module Macro
    module Filtering
      class << self
        def for(_input, options)
          set_defaults(options)

          options['model'] = apply_filtering(options)

          true
        end

        private

        def set_defaults(options)
          {
            'filtering.filters' => []
          }.each_pair do |key, value|
            options[key] = value unless options[key]
          end
        end

        def apply_filtering(options)
          relation = options['model']

          options['filtering.filters'].each do |filter|
            value = options['params'][filter.param]
            next unless value.present?

            relation = filter.apply(relation: relation, value: value)
          end

          relation
        end
      end
    end
  end
end
