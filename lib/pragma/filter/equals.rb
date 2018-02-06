# frozen_string_literal: true

module Pragma
  module Filter
    class Equals < Base
      attr_reader :column

      def initialize(column:, **other)
        super(**other)
        @column = column
      end

      def apply(relation:, value:)
        relation.where(column => value)
      end
    end
  end
end
