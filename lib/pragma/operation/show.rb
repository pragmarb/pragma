# frozen_string_literal: true
module Pragma
  module Operation
    # Finds the requested record, authorizes it and decorates it.
    #
    # @author Alessandro Desantis
    class Show < Pragma::Operation::Base
      step Macro::Classes()
      step Macro::Model(), fail_fast: true
      step Macro::Policy(), fail_fast: true
      step Macro::Decorator()
    end
  end
end
