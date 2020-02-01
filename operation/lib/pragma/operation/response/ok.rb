# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 200 Ok HTTP response.
      class Ok < Response
        # Initializes the response.
        #
        # @param entity [Object] the response's entity
        # @param headers [Hash] the response's headers
        def initialize(entity: nil, headers: {})
          super(status: 200, entity: entity, headers: headers)
        end
      end
    end
  end
end
