# frozen_string_literal: true
module Pragma
  module Operation
    # Finds the requested record, authorizes it and decorates it.
    #
    # @author Alessandro Desantis
    class Show < Pragma::Operation::Base
      step Macro::Classes()
      step Macro::Model()
      step Macro::Policy()
      step Macro::Decorator()
    end
  end
end
