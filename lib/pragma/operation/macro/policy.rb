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
        def self.for(input, name, options)
          policy = options["policy.#{name}.class"].new(options['current_user'], options['model'])

          options["result.policy.#{name}"] = Trailblazer::Operation::Result.new(
            policy.send("#{input.class.operation_name}?"),
            'policy' => policy
          )

          options["result.policy.#{name}"].success?
        end
      end
    end
  end
end
