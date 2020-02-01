# frozen_string_literal: true

module Pragma
  module Resource
    module Macro

      module Pagination
        class << self
          def for(_input, options)
            set_defaults(options)
            normalize_params(options)

            unless validate_params(options)
              handle_invalid_contract(options)
              return false
            end

            pagination_options = {
              page: page(options, **options),
              per_page: per_page(options, **options)
            }

            options['model'] = if defined?(Kaminari)
                                 options['model'].page(pagination_options[:page]).per(pagination_options[:per_page])
                               elsif defined?(WillPaginate)
                                 options['model'].paginate(pagination_options)
                               else
                                 fail 'Cannot find a supported pagination adapter (tried Kaminari, will_paginate)!'
            end
          end

          private

          def set_defaults(options)
            {
              'pagination.page_param' => :page,
              'pagination.per_page_param' => :per_page,
              'pagination.default_per_page' => 30,
              'pagination.max_per_page' => 100
            }.each_pair do |key, value|
              options[key] = value unless options[key]
            end
          end

          def normalize_params(options)
            # This is required because Rails treats all incoming parameters as strings, since it
            # can't distinguish. Maybe there's a better way to do it?
            options['params'].tap do |p|
              %w[pagination.page_param pagination.per_page_param].each do |key|
                p[options[key]] = p[options[key]].to_i if p[options[key]]&.respond_to?(:to_i)
              end
            end
          end

          def validate_params(options)
            options['contract.pagination'] = Dry::Validation.Schema do
              optional(options['pagination.page_param']).filled { int? & gteq?(1) }
              optional(options['pagination.per_page_param']).filled do
                int? & (gteq?(1) & lteq?(options['pagination.max_per_page']))
              end
            end

            options['result.contract.pagination'] = options['contract.pagination'].call(
              options['params']
            )

            options['result.contract.pagination'].errors.empty?
          end

          def handle_invalid_contract(options)
            options['result.response'] = Operation::Response::UnprocessableEntity.new(
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
