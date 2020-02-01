# frozen_string_literal: true

module Pragma
  module Operation
    # This is the base class all your operations should extend.
    #
    # @author Alessandro Desantis
    class Base < Trailblazer::Operation
      class << self
        # Returns the name of this operation.
        #
        # For instance, if the operation is called +API::V1::Post::Operation::Create+, returns
        # +create+.
        #
        # @return [Symbol]
        def operation_name
          name.split('::').last
              .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
              .gsub(/([a-z\d])([A-Z])/, '\1_\2')
              .tr('-', '_')
              .downcase
              .to_sym
        end
      end
    end
  end
end
