# frozen_string_literal: true

module Pragma
  module Operation
    # Finds an existing record, destroys it and responds 204 No Content.
    #
    # @author Alessandro Desantis
    class Destroy < Pragma::Operation::Base
      step Macro::Classes()
      step Macro::Model(:find_by)
      step Macro::Policy()
      step :destroy!
      step :respond!

      def destroy!(_options, model:, **)
        unless model.destroy
          options['result.response'] = Response::UnprocessableEntity.new(
            errors: model.errors
          ).decorate_with(Decorator::Error)

          return false
        end

        true
      end

      def respond!(options)
        options['result.response'] = Response::NoContent.new
      end
    end
  end
end
