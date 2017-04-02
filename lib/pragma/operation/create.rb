# frozen_string_literal: true
require 'trailblazer/operation/contract'
require 'trailblazer/operation/validate'
require 'trailblazer/operation/persist'

module Pragma
  module Operation
    # Creates a new record and responds with the decorated record.
    #
    # @author Alessandro Desantis
    class Create < Pragma::Operation::Base
      step Macro::Classes()
      step :build!
      step Macro::Policy(), fail_fast: true
      step Trailblazer::Operation::Contract::Build()
      step Trailblazer::Operation::Contract::Validate()
      failure :handle_invalid_contract!
      step Trailblazer::Operation::Contract::Persist()
      failure :handle_invalid_model!
      step :respond!
      step Macro::Decorator()

      def build!(options)
        options['model'] = options['model.class'].new
      end

      def handle_invalid_contract!(options)
        options['result.response'].status = 422
        options['result.response'] = Response::UnprocessableEntity.new(errors: options['contract.default'].errors)
      end

      def handle_invalid_model!(options)
        options['result.response'].status = 422
        options['result.response'] = Response::UnprocessableEntity.new(errors: options['model'].errors)
      end

      def respond!(options)
        options['result.response'].status = 201
      end
    end
  end
end
