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
            set_defaults(options)

            unless validate_params(options)
              handle_invalid_contract(options)
              return false
            end

            options['model'] = options['model'].paginate(
              page: page(options, **options),
              per_page: per_page(options, **options)
            )
          end

          private

          def set_defaults(options)
            {
              'pagination.page_param' => :page,
              'pagination.per_page_param' => :per_page,
              'pagination.default_per_page' => 30,
              'pagination.max_per_page' => 100
            }.each_pair do |key, value|
              options[key] ||= value
            end
          end

          def validate_params(options)
            options['contract.pagination'] = Dry::Validation.Schema do
              optional(options['pagination.page_param']).filled { int? & gteq?(1) }
              optional(options['pagination.per_page_param']).filled { int? & (gteq?(1) & lteq?(options['pagination.max_per_page'])) }
            end

            options['result.contract.pagination'] = options['contract.pagination'].call(options['params'])

            options['result.contract.pagination'].errors.empty?
          end

          def handle_invalid_contract(options)
            options['result.response'] = Response::UnprocessableEntity.new(
              errors: options['result.contract.pagination'].errors
            ).decorate_with(Pragma::Decorator::Error)
          end

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
