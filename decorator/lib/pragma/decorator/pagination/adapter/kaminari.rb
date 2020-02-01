# frozen_string_literal: true

module Pragma
  module Decorator
    module Pagination
      module Adapter # :nodoc:
        # This adapter provides support for retireving pagination information from collections
        # paginated with {https://github.com/kaminari/kaminari Kaminari}.
        #
        # @api private
        class Kaminari < Base
          class << self
            # Returns whether this adapter supports the given collection.
            #
            # Esnures that the +Kaminari+ constant is defined and that the collection responds to
            # +#prev_page+.
            #
            # @return [Boolean] whether the adapter supports the given collection
            #
            # @see Adapter.load_adaptor
            def supports?(collection)
              Object.const_defined?('Kaminari') && collection.respond_to?(:prev_page)
            end
          end

          # Returns the total number of entries in the collection.
          #
          # @return [Integer] the total number of entries in the collection
          def total_entries
            collection.total_count
          end

          # Returns the number of entries per page in the collection.
          #
          # @return [Integer] the number of entries per page in the collection
          def per_page
            collection.limit_value
          end

          # Returns the total number of pages in the collection.
          #
          # @return [Integer] the total number of pages in the collection
          def total_pages
            collection.total_pages
          end

          # Returns the number of the previous page, if any.
          #
          # @return [Integer|NilClass] the number of the previous page, if any
          def previous_page
            collection.prev_page
          end

          # Returns the number of the current page.
          #
          # @return [Integer] the number of the current page
          def current_page
            collection.current_page
          end

          # Returns the number of the next page, if any.
          #
          # @return [Integer|NilClass] the number of the next page, if any
          def next_page
            collection.next_page
          end
        end
      end
    end
  end
end
