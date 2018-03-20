# frozen_string_literal: true

module Pragma
  module Filter
    class Boolean < Base
      attr_reader :scope

      def initialize(scope:, **other)
        super(**other)
        @scope = scope
      end

      def apply(relation:, **)
        relation.public_send(scope)
      end
    end
  end
end
