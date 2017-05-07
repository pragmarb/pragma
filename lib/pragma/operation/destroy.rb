# frozen_string_literal: true

module Pragma
  module Operation
    # Finds an existing record, destroys it and responds 204 No Content.
    #
    # @author Alessandro Desantis
    class Destroy < Pragma::Operation::Base
      step Macro::Classes()
      step Macro::Model(:find_by), fail_fast: true
      step Macro::Policy(), fail_fast: true
      step :destroy!
      failure :handle_invalid_model!, fail_fast: true
      step :respond!

      def destroy!(_options, model:, **)
        model.destroy
      end

      def handle_invalid_model!(options, model:, **)
        options['result.response'] = Response::UnprocessableEntity.new(
          errors: model.errors
        ).decorate_with(Decorator::Error)
      end

      def respond!(options)
        options['result.response'] = Response::NoContent.new
      end
    end
  end
end
