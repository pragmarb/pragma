# frozen_string_literal: true

module Pragma
  module Filter
    class Scope < Base
      attr_reader :scope

      def initialize(scope:, **other)
        super(**other)
        @scope = scope
      end

      def apply(relation:, value:)
        relation.public_send(scope, value)
      end
    end
  end
end
