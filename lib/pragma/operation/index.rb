module Pragma
  module Operation
    class Index < Pragma::Operation::AwareBase
      class << self
        def build_decorator(*)
          @decorator ||= computed_decorator_klass if class_exists(computed_decorator_klass)
          super
        end

        def build_policy(*)
          @policy ||= computed_policy_klass if class_exists(computed_policy_klass)
          super
        end

        def build_contract(*)
          @contract ||= computed_contract_klass if class_exists(computed_contract_klass)
          super
        end

        private

        def computed_decorator_klass
          name.split('::')[0..-3] << 'Decorator'
        end

        def computed_policy_klass
          name.split('::')[0..-3] << 'Policy'
        end

        def computed_contract_klass
          name_parts = name.split('::')
          name_parts[0..-3] << 'Decorator' << name_parts.last
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
