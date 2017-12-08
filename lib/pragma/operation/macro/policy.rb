# frozen_string_literal: true

require 'trailblazer/operation/pundit'

module Pragma
  module Operation
    module Macro
      def self.Policy(name: :default)
        step = ->(input, options) { Policy.for(input, name, options) }
        [step, name: "policy.#{name}"]
      end

      module Policy
        class << self
          def for(input, name, options)
            policy = options["policy.#{name}.class"].new(options['current_user'], options['model'])

            options["result.policy.#{name}"] = Trailblazer::Operation::Result.new(
              policy.send("#{input.class.operation_name}?"),
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
