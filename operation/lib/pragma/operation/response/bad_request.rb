# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 400 Bad Request HTTP response.
      class BadRequest < Response
        def initialize(
          entity: Error.new(error_type: :bad_request, error_message: 'This request is malformed.'),
          headers: {}
        )
          super(status: 400, entity: entity, headers: headers)
        end
      end
    end
  end
end
