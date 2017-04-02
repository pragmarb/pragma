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
      step Macro::Policy()
      failure :handle_unauthorized!, fail_fast: true
      step Trailblazer::Operation::Contract::Build()
      step Trailblazer::Operation::Contract::Validate()
      failure :handle_invalid_contract!, fail_fast: true
      step Trailblazer::Operation::Contract::Persist()
      failure :handle_invalid_model!, fail_fast: true
      step Macro::Decorator()
      step :respond!

      def build!(options)
        options['model'] = options['model.class'].new
      end

      def handle_unauthorized!(options)
        options['result.response'] = Response::Forbidden.new.decorate_with(Decorator::Error)
      end

      def handle_invalid_contract!(options)
        options['result.response'] = Response::UnprocessableEntity.new(
          errors: options['contract.default'].errors
        ).decorate_with(Decorator::Error)
      end

      def handle_invalid_model!(options)
        options['result.response'] = Response::UnprocessableEntity.new(
          errors: options['model'].errors
        ).decorate_with(Decorator::Error)
      end

      def respond!(options)
        options['result.response'] = Response::Created.new(
          entity: options['result.decorator.default']
        )
      end
    end
  end
end
