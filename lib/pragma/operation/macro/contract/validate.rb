# frozen_string_literal: true
require 'trailblazer/operation/validate'

module Pragma
  module Operation
    module Macro
      module Contract
        def self.Validate(*args)
          Trailblazer::Operation::Contract::Validate(*args)
        end
      end
    end
  end
end
