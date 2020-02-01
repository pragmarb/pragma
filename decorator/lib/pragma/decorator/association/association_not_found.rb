# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      # This is raised when a non-existing association is expanded.
      class AssociationNotFound < ExpansionError
        # @!attribute [r] property
        #   @return [String|Sybmol] the property the user tried to expand
        attr_reader :property

        # Initializes the rror.
        #
        # @param property [String|Symbol] the property the user tried to expand
        def initialize(property)
          @property = property
          super "The '#{property}' association is not defined."
        end
      end
    end
  end
end
