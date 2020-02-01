# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 402 Payment Required HTTP response.
      class PaymentRequired < Response
        # Initializes the response.
        #
        # @param entity [Object] the response's entity
        # @param headers [Hash] the response's headers
        def initialize(
          entity: Error.new(
            error_type: :payment_required,
            error_message: 'This resource requires payment.'
          ),
          headers: {}
        )
          super(status: 402, entity: entity, headers: headers)
        end
      end
    end
  end
end
