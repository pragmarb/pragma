# frozen_string_literal: true

module Pragma
  module Operation
    class Response
      class NotFound < Response
        def initialize(
          status: 404,
          entity: Decorator::Error.new(
            error_type: :not_found,
            error_message: 'The requested resource could not be found.'
          ),
          headers: {}
        )
          super(status: status, entity: entity, headers: headers)
        end
      end
    end
  end
end
