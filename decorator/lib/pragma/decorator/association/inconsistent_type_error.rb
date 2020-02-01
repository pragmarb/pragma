# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      # This error is raised when an association's type is different from its type as reported by
      # the model's reflection.
      #
      # @author Alessandro Desantis
      class InconsistentTypeError < StandardError
        # Initializes the error.
        #
        # @param decorator [Base] the decorator where the association is defined
        # @param reflection [Reflection] the reflection of the inconsistent association
        # @param model_type [Symbol|String] the real type of the association
        def initialize(decorator:, reflection:, model_type:)
          message = <<~MSG.tr("\n", ' ')
            #{decorator.class}: Association #{reflection.attribute} is defined as #{model_type} on
            the model, but as #{reflection.type} in the decorator.
          MSG

          super message
        end
      end
    end
  end
end
