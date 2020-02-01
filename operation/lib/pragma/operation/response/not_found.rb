# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 404 Not Found HTTP response.
      class NotFound < Response
        # Initializes the response.
        #
        # @param entity [Object] the response's entity
        # @param headers [Hash] the response's headers
        def initialize(
          entity: Error.new(
            error_type: :not_found,
            error_message: 'The requested resource could not be found.'
          ),
          headers: {}
        )
          super(status: 404, entity: entity, headers: headers)
        end
      end
    end
  end
end
