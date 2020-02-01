# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 500 Internal Server Error HTTP response.
      class InternalServerError < Response
        # Initializes the response.
        #
        # @param entity [Object] the response's entity
        # @param headers [Hash] the response's headers
        def initialize(
          entity: Error.new(
            error_type: :internal_server_error,
            error_message: 'There was an error processing your request.'
          ),
          headers: {}
        )
          super(status: 500, entity: entity, headers: headers)
        end
      end
    end
  end
end
