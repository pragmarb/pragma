# frozen_string_literal: true
module Pragma
  module Operation
    # Provides support for inferring decorator, policy and contract names from the class name.
    #
    # @author Alessandro Desantis
    module Defaults
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods # :nodoc:
        # Returns the decorator class for the current resource (if the inferred class exists).
        #
        # If the operation name is +API::V1::Post::Operation::Show+, returns
        # +API::V1::Post::Decorator+.
        #
        # @return [Class]
        def decorator_klass
          super || (
            Object.const_get(computed_decorator_klass) if class_exists?(computed_decorator_klass)
          )
        end

        # Returns the policy class for the current resource (if the inferred class exists).
        #
        # If the operation name is +API::V1::Post::Operation::Show+, returns
        # +API::V1::Post::Policy+.
        #
        # @return [Class]
        def policy_klass
          super || (
            Object.const_get(computed_policy_klass) if class_exists?(computed_policy_klass)
          )
        end

        # Returns the contract class for the current resource (if the inferred class exists).
        #
        # If the operation name is +API::V1::Post::Operation::Create+, returns
        # +API::V1::Post::Contract::Create+.
        #
        # @return [Class]
        def contract_klass
          super || (
            Object.const_get(computed_contract_klass) if class_exists?(computed_contract_klass)
          )
        end

        # Returns the model class for the current resource (if the inferred class exists).
        #
        # If the operation name is +API::V1::Post::Operation::Create+, returns +::Post+.
        def model_klass
          Object.const_get("::#{name.split('::')[0..-3].last}")
        end

        private

        def computed_decorator_klass
          (name.split('::')[0..-3] << 'Decorator').join('::')
        end

        def computed_policy_klass
          (name.split('::')[0..-3] << 'Policy').join('::')
        end

        def computed_contract_klass
          name_parts = name.split('::')
          (name_parts[0..-3] << 'Decorator' << name_parts.last).join('::')
        end

        def class_exists?(klass)
          Object.const_get(klass)
          true
        rescue NameError
          false
        end
      end
    end
  end
end
