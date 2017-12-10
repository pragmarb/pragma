# frozen_string_literal: true

module Pragma
  module Operation
    module Filter
      class Equals < Base
        def apply(relation:, value:)
          relation.where(column => value)
        end
      end
    end
  end
end
