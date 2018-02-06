# frozen_string_literal: true

module Pragma
  module Filter
    class Like < Base
      attr_reader :column

      def initialize(column:, **other)
        super(**other)
        @column = column
      end

      def apply(relation:, value:)
        relation.where("#{column} LIKE ?", "%#{value}%")
      end
    end
  end
end
