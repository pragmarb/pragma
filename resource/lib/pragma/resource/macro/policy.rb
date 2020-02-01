# frozen_string_literal: true

module Pragma
  module Resource
    module Macro
      module Policy
        class << self
          def for(input, name, options, action = nil)
            klass = Macro.require_skill('Policy', "policy.#{name}.class", options)

            policy = klass.new(
              options['policy.context'] || options['current_user'],
              options['model']
            )

            action_name = action.is_a?(Proc) ? action.call(options) : action
            action_name ||= input.class.operation_name

            options["result.policy.#{name}"] = Trailblazer::Operation::Result.new(
              policy.send("#{action_name}?"),
              'policy' => policy
            )

            unless options["result.policy.#{name}"].success?
              handle_unauthorized!(options)
              return false
            end

            true
          end

          private

          def handle_unauthorized!(options)
            options['result.response'] = Pragma::Operation::Response::Forbidden.new.decorate_with(
              Pragma::Decorator::Error
            )
          end
        end
      end
    end
  end
end
