# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      # Represents the 409 Conflict HTTP response.
      class Conflict < Response
        def initialize(
          entity: Error.new(
            error_type: :conflict,
            error_message: 'Your request is in conflict with other content on this server.'
          ),
          headers: {}
        )
          super(status: 409, entity: entity, headers: headers)
        end
      end
    end
  end
end
