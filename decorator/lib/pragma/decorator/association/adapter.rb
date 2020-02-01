# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      # Adapters make associations ORM-independent by providing support for multiple underlying
      # libraries like ActiveRecord and simple POROs.
      #
      # @api private
      module Adapter
        include Adaptor::Loader
        register ActiveRecord, Poro
      end
    end
  end
end
