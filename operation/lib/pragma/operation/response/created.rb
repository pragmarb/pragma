# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 201 Created HTTP response.
      class Created < Response
        # Initializes the response.
        #
        # @param entity [Object] the response's entity
        # @param headers [Hash] the response's headers
        def initialize(entity: nil, headers: {})
          super(status: 201, entity: entity, headers: headers)
        end
      end
    end
  end
end
