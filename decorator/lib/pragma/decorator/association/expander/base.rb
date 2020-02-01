# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      module Expander
        class Base
          attr_reader :relation

          class << self
            def supports?(_relation)
              fail NotImplementedError
            end
          end

          def initialize(relation)
            @relation = relation
          end

          def include_associations(_expands)
            fail NotImplementedError
          end
        end
      end
    end
  end
end
