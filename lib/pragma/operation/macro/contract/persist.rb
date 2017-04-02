# frozen_string_literal: true

require 'trailblazer/operation/persist'

module Pragma
  module Operation
    module Macro
      module Contract
        def self.Persist(*args)
          Trailblazer::Operation::Contract::Persist(*args)
        end
      end
    end
  end
end
