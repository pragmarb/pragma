# frozen_string_literal: true

module Pragma
  module Operation
    module Filter
      class Like < Base
        def apply(relation:, value:)
          relation.where("#{column} LIKE ?", "%#{value}%")
        end
      end
    end
  end
end
