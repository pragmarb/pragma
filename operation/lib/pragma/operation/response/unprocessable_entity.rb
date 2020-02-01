# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 422 Unprocessable Entity HTTP response.
      class UnprocessableEntity < Response
        # Initializes the response.
        #
        # You can provide either +entity+ or +errors+, but not both. If you provide +entity+, the
        # standard response's entity will be replaced with yours. If you provide +errors+, the
        # standard entity will be used and your errors will be added to the meta.
        #
        # @param entity [Object] the response's entity
        # @param headers [Hash] the response's headers
        # @param errors [Hash] the response's errors
        #
        # @raise [ArgumentError] if both +entity+ and +errors+ are provided
        def initialize(entity: nil, headers: {}, errors: nil)
          fail ArgumentError, 'You cannot provide both :entity and :errors!' if entity && errors

          entity ||= Error.new(
            error_type: :unprocessable_entity,
            error_message: 'The provided resource is in an unexpected format.',
            meta: {
              errors: errors || {}
            }
          )

          super(status: 422, entity: entity, headers: headers)
        end
      end
    end
  end
end
