# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      module Adapter
        # The base association adapter, defining the interface for the implementations.
        #
        # @abstract Subclass and override {.supports?}, {#primary_key} and {#full_object} to
        #   create a new adapter
        #
        # @api private
        class Base
          # @!attribute [r] bond
          #   @return [Bond] the bond this adapter has been instantiated with
          attr_reader :bond

          # Initializes the adapter.
          #
          # @param bond [Bond] the bond to use
          def initialize(bond)
            @bond = bond
          end

          # Returns the primary key of the association represented by the provided bond.
          #
          # @return [String|Integer] the PK
          #
          # @abstract
          def primary_key
            fail NotImplementedError
          end

          # Returns the full object of the association represented by the provided bond.
          #
          # @return [Object] the full object
          #
          # @abstract
          def full_object
            fail NotImplementedError
          end

          protected

          # This is a convenience method returning the reflection defined on the bond.
          #
          # @return [Reflection] the bond's reflection
          #
          # @see Bond#reflection
          def reflection
            bond.reflection
          end

          # This is a convenience method returning the reflection defined on the bond.
          #
          # @return [Object] the bond's associated object
          #
          # @see Bond#associated_object
          def associated_object
            bond.associated_object
          end

          # This is a convenience method returning the model defined on the bond.
          #
          # @return [Reflection] the bond's model
          #
          # @see Bond#model
          def model
            bond.model
          end
        end
      end
    end
  end
end
