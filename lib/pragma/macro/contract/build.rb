# frozen_string_literal: true

require 'trailblazer/operation/contract'

module Pragma
  module Macro
    module Contract
      def self.Build(name: 'default', constant: nil, builder: nil)
        step = lambda do |input, options|
          Macro.require_skill('Contract::Build', "contract.#{name}.class", options)

          Trailblazer::Operation::Contract::Build.for(
            input,
            options,
            name: name,
            constant: constant,
            builder: builder
          ).tap do |contract|
            contract.current_user = options['current_user']
          end
        end

        [step, name: "contract.#{name}.build"]
      end
    end
  end
end
