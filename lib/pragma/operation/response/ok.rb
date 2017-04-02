# frozen_string_literal: true
module Pragma
  module Operation
    class Response
      class Ok < Response
        def initialize(status: 200, entity: nil, headers: {})
          super(status: status, entity: entity, headers: headers)
        end
      end
    end
  end
end
