# frozen_string_literal: true

module Pragma
  module AssociationIncluder
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
