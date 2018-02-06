# frozen_string_literal: true

module Pragma
  module Filter
    class Base
      attr_reader :param, :column

      def initialize(param:, column:)
        @param = param.to_sym
        @column = column.to_sym
      end

      def apply(*)
        fail NotImplementedError
      end
    end
  end
end
