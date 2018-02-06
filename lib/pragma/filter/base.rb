# frozen_string_literal: true

module Pragma
  module Filter
    class Base
      attr_reader :param

      def initialize(param:)
        @param = param.to_sym
      end

      def apply(*)
        fail NotImplementedError
      end
    end
  end
end
