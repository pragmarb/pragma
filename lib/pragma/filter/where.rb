# frozen_string_literal: true

module Pragma
  module Filter
    class Where < Base
      attr_reader :condition

      def initialize(condition:, **other)
        super(**other)
        @condition = condition
      end

      def apply(relation:, value:)
        relation.where(condition, value: value)
      end
    end
  end
end
