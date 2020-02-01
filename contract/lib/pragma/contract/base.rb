# frozen_string_literal: true

require 'reform/form/coercion'
require 'reform/form/dry'

module Pragma
  module Contract
    # This is the base contract that all of your resource-specific contracts should inherit from.
    #
    # It's just an extension of +Reform::Form+ with some helper methods for coercion.
    #
    # @author Alessandro Desantis
    class Base < Reform::Form
      feature Reform::Form::Coercion
      feature Pragma::Contract::Coercion
      feature Reform::Form::Dry
      feature Pragma::Contract::ModelFinder

      property :current_user, virtual: true
    end
  end
end
