# frozen_string_literal: true

module Pragma
  module Filter
    class Ilike < Base
      def apply(relation:, value:)
        relation.where("#{column} ILIKE ?", "%#{value}%")
      end
    end
  end
end
