# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 403 Forbidden HTTP response.
      class Forbidden < Response
        # Initializes the response.
        #
        # @param entity [Object] the response's entity
        # @param headers [Hash] the response's headers
        def initialize(
          entity: Error.new(
            error_type: :forbidden,
            error_message: 'You are not authorized to access the requested resource.'
          ),
          headers: {}
        )
          super(status: 403, entity: entity, headers: headers)
        end
      end
    end
  end
end
