# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      module Expander
        class Poro < Base
          class << self
            def supports?(_relation)
              true
            end
          end

          def include_associations(_expands)
            relation
          end
        end
      end
    end
  end
end
