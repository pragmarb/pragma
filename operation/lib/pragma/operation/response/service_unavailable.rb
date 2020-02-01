# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 503 Service Unavailable HTTP response.
      class ServiceUnavailable < Response
        # Initializes the response.
        #
        # @param entity [Object] the response's entity
        # @param headers [Hash] the response's headers
        def initialize(
          entity: Error.new(
            error_type: :service_unavailable,
            error_message: 'This resource is not available right now. Try later.'
          ),
          headers: {}
        )
          super(status: 503, entity: entity, headers: headers)
        end
      end
    end
  end
end
