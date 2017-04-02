# frozen_string_literal: true
module Pragma
  module Operation
    class Response
      class Created < Response
        def initialize(status: 201, entity: nil, headers: {})
          super(status: status, entity: entity, headers: headers)
        end
      end
    end
  end
end
