# frozen_string_literal: true

module Pragma
  module Decorator
    class Error < Pragma::Decorator::Base
      include Pragma::Decorator::Type

      property :error_type
      property :error_message
      property :meta

      def type
        :error
      end
    end
  end
end
