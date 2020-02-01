# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      module Adapter
        # This is the fallback adapter that is used when no other adpater is compatible with a
        # model. It simply calls +#id+ on the associated object to get the PK and returns the
        # associated object itself when expanding.
        #
        # @api private
        class Poro < Base
          include Adaptor

          class << self
            # Returns whether the adapter supports the bond.
            #
            # Since this is the default adapter, this always returns +true+.
            #
            # @param _bond [Bond] the bond to check
            #
            # @return [Boolean] always +true+
            def supports?(_bond)
              true
            end
          end

          # Returns the PK of the associated object.
          #
          # This adapter simply calls +#id+ on the associated object or returns +nil+ if there is
          # no associated object.
          #
          # @return [Integer|String|NilClass] the PK of the associated object
          def primary_key
            associated_object&.id
          end

          # Returns the expanded associated object.
          #
          # This adapter simply returns the associated object itself.
          #
          # @return [Object] the associated object
          def full_object
            associated_object
          end
        end
      end
    end
  end
end
