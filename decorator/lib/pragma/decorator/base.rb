# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Pragma
  module Decorator
    # This is the base decorator that all your resource-specific decorators should extend from.
    #
    # It is already configured to render your resources as JSON.
    class Base < Roar::Decorator
      feature Roar::JSON

      defaults render_nil: true
    end
  end
end
