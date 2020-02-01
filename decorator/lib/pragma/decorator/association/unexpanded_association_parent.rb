# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      # This is raised when the user expanded a nested association without expanding its parent.
      class UnexpandedAssociationParent < ExpansionError
        # @!attribute [r] child
        #   @return [String|Symbol] the name of the child association
        #
        # @!attribute [r] parent
        #   @return [String|Symbol] the name of the parent association
        attr_reader :child, :parent

        # Initializes the error.
        #
        # @param child [String|Symbol] the name of the child association
        # @param parent [String|Symbol] the name of the parent association
        def initialize(child, parent)
          @child = child
          @parent = parent

          super "The '#{child}' association is expanded, but its parent '#{parent}' is not."
        end
      end
    end
  end
end
