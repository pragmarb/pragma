# frozen_string_literal: true

module Pragma
  module Operation
    # Finds an existing record, updates it and responds with the decorated record.
    #
    # @author Alessandro Desantis
    class Update < Pragma::Operation::Base
      step Macro::Classes()
      step Macro::Model(:find_by)
      failure :handle_model_not_found!, fail_fast: true
      step Macro::Policy(), fail_fast: true
      step Macro::Contract::Build()
      step Macro::Contract::Validate(), fail_fast: true
      step Macro::Contract::Persist(), fail_fast: true
      step Macro::Decorator()
      step :respond!

      def handle_model_not_found!(options)
        options['result.response'] = Response::NotFound.new.decorate_with(Decorator::Error)
      end

      def handle_invalid_contract!(options)
        options['result.response'] = Response::UnprocessableEntity.new(
          errors: options['contract.default'].errors
        ).decorate_with(Decorator::Error)
      end

      def handle_invalid_model!(options, model:, **)
        options['result.response'] = Response::UnprocessableEntity.new(
          errors: model.errors
        ).decorate_with(Decorator::Error)
      end

      def respond!(options)
        options['result.response'] = Response::Ok.new(entity: options['result.decorator.default'])
      end
    end
  end
end
