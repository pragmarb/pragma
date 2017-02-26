# frozen_string_literal: true
module Pragma
  module Operation
    class Response
      class Forbidden < Response
        def initialize(
          status: 403,
          entity: Decorator::Error.new(
            error_type: :forbidden,
            error_message: 'You are not authorized to access the requested resource.'
          ),
          headers: {}
        )
          super(status: status, entity: entity, headers: headers)
        end
      end
    end
  end
end
