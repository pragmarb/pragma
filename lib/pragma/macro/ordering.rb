# frozen_string_literal: true

module Pragma
  module Macro
    module Ordering
      class << self
        def for(_input, options)
          set_defaults(options)

          unless validate_params(options)
            handle_invalid_contract(options)
            return false
          end

          order_column = order_column(options)

          if order_column
            direction = order_direction(options)
            options['model'] = options['model'].order("#{order_column} #{direction}")
          end

          true
        end

        private

        def set_defaults(options)
          default_column = (:created_at if options['model.class']&.method_defined?(:created_at))

          {
            'ordering.columns' => [default_column].compact,
            'ordering.default_column' => default_column,
            'ordering.default_direction' => :desc,
            'ordering.column_param' => :order_property,
            'ordering.direction_param' => :order_direction
          }.each_pair do |key, value|
            options[key] = value unless options[key]
          end
        end

        def validate_params(options)
          options['contract.ordering'] = Dry::Validation.Schema do
            optional(options['ordering.column_param']).filled do
              str? & included_in?(options['ordering.columns'].map(&:to_s))
            end
            optional(options['ordering.direction_param']).filled do
              str? & included_in?(%w[asc desc ASC DESC])
            end
          end

          options['result.contract.ordering'] = options['contract.ordering'].call(
            options['params']
          )

          options['result.contract.ordering'].errors.empty?
        end

        def handle_invalid_contract(options)
          options['result.response'] = Operation::Response::UnprocessableEntity.new(
            errors: options['result.contract.ordering'].errors
          ).decorate_with(Pragma::Decorator::Error)
        end

        def order_column(options)
          params = options['params']
          params[options['ordering.column_param']] || options['ordering.default_column']
        end

        def order_direction(options)
          params = options['params']
          params[options['ordering.direction_param']] || options['ordering.default_direction']
        end
      end
    end
  end
end
