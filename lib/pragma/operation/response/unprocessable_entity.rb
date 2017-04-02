module Pragma
  module Operation
    class Response
      class UnprocessableEntity < Response
        def initialize(status: 422, entity: nil, headers: {}, errors: nil)
          fail ArgumentError, 'You cannot provide both :entity and :errors!' if entity && errors

          entity ||= Decorator::Error.new(
            error_type: :unprocessable_entity,
            error_message: 'The provided resource is in an unexpected format.',
            meta: {
              errors: errors || {}
            }
          )

          super(
            status: status,
            entity: entity,
            headers: headers
          )
        end
      end
    end
  end
end
