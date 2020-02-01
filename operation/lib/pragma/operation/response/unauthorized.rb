# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 401 Unauthorized HTTP response.
      class Unauthorized < Response
        # Initializes the response.
        #
        # @param entity [Object] the response's entity
        # @param headers [Hash] the response's headers
        def initialize(
          entity: Error.new(
            error_type: :unauthorized,
            error_message: 'This resource requires authentication.'
          ),
          headers: {}
        )
          super(status: 401, entity: entity, headers: headers)
        end
      end
    end
  end
end
