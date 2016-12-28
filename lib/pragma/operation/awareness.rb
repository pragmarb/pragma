# frozen_string_literal: true
module Pragma
  module Operation
    module Awareness
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods # :nodoc:
        def build_decorator(*)
          @decorator ||= computed_decorator_klass if class_exists?(computed_decorator_klass)
          super
        end

        def build_policy(*)
          @policy ||= computed_policy_klass if class_exists?(computed_policy_klass)
          super
        end

        def build_contract(*)
          @contract ||= computed_contract_klass if class_exists?(computed_contract_klass)
          super
        end

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
