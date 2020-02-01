# frozen_string_literal: true

module Pragma
  module Operation
    # A generic error entity to hold error information for HTTP responses.
    #
    # This format is not mandatory, but recommended for consistency and convenience.
    class Error
      # @!attribute [r] error_type
      #   @return [Symbol|String] a machine-readable error type
      #
      # @!attribute [r] error_message
      #   @return [String] a human-readable error message
      #
      # @!attribute [r] meta
      #   @return [Hash] metadata about the error
      attr_reader :error_type, :error_message, :meta

      # Creates a new error entity.
      #
      # @param error_type [Symbol|String] a machine-readable error type
      # @param error_message [String] a human-readable error message
      # @param meta [Hash] metadata about the error
      def initialize(error_type:, error_message:, meta: {})
        @error_type = error_type
        @error_message = error_message
        @meta = meta
      end

      # Converts the entity to a hash ready to be dumped as JSON.
      #
      # @return [Hash]
      def as_json(*)
        {
          error_type: error_type,
          error_message: error_message,
          meta: meta
        }
      end

      # Dumps the JSON representation as a JSON string.
      #
      # @return [String]
      #
      # @see #as_json
      def to_json(*_args)
        JSON.dump as_json
      end
    end
  end
end
