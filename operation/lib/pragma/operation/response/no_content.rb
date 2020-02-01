# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 204 No Content HTTP response.
      class NoContent < Response
        # Initializes the response.
        #
        # @param headers [Hash] the response's headers
        def initialize(headers: {})
          super(status: 204, entity: nil, headers: headers)
        end
      end
    end
  end
end
