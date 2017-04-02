require 'trailblazer/operation/contract'

module Pragma
  module Operation
    module Macro
      module Contract
        def self.Build(name: 'default', constant: nil, builder: nil)
          step = lambda do |input, options|
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

          [step, name: 'contract.build']
        end
      end
    end
  end
end
