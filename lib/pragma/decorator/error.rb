# frozen_string_literal: true
module Pragma
  module Decorator
    class Error < Pragma::Decorator::Base
      property :error_type
      property :error_message
    end
  end
end
