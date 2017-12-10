# frozen_string_literal: true

module Pragma
  module Operation
    module Macro
      def self.Filtering
        step = ->(input, options) { Filtering.for(input, options) }
        [step, name: 'filtering']
      end

      module Filtering
        class << self
          def for(_input, options)
            set_defaults(options)

            options['model'] = apply_filtering(options)

            true
          end

          private

          def set_defaults(options)
            hash_options = options.to_hash

            {
              'filtering.filters' => []
            }.each_pair do |key, value|
              options[key] = value unless hash_options.key?(key.to_sym)
            end
          end

          def apply_filtering(options)
            relation = options['model']

            options['filtering.filters'].each do |filter|
              value = options['params'][filter.param]
              next unless value.present?

              relation = filter.apply(relation: options['model'], value: value)
            end

            relation
          end
        end
      end
    end
  end
end
