# frozen_string_literal: true

module Pragma
  module Decorator
    module Pagination
      # Adapters make pagination library-independent by providing support for multiple underlying
      # libraries like Kaminari and will_paginate.
      #
      # @api private
      module Adapter
        include Adaptor::Loader
        register Kaminari, WillPaginate
      end
    end
  end
end
