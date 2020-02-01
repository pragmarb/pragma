# frozen_string_literal: true

module Pragma
  module Decorator
    module Pagination
      module Adapter
        # This is the base pagination adapter.
        #
        # @abstract Subclass and override the abstract methods to implement an adapter
        #
        # @api private
        class Base
          # @!attribute [r] collection
          #   @return [Object] the collection this adapter is working with
          attr_reader :collection

          # Initializes the adapter.
          #
          # @param collection [Object] the collection to work with
          def initialize(collection)
            @collection = collection
          end

          # Returns the total number of entries in the collection.
          #
          # @return [Integer] the total number of entries in the collection
          def total_entries
            fail NotImplementedError
          end

          # Returns the number of entries per page in the collection.
          #
          # @return [Integer] the number of entries per page in the collection
          def per_page
            fail NotImplementedError
          end

          # Returns the total number of pages in the collection.
          #
          # @return [Integer] the total number of pages in the collection
          def total_pages
            fail NotImplementedError
          end

          # Returns the number of the previous page, if any.
          #
          # @return [Integer|NilClass] the number of the previous page, if any
          def previous_page
            fail NotImplementedError
          end

          # Returns the number of the current page.
          #
          # @return [Integer] the number of the current page
          def current_page
            fail NotImplementedError
          end

          # Returns the number of the next page, if any.
          #
          # @return [Integer|NilClass] the number of the next page, if any
          def next_page
            fail NotImplementedError
          end
        end
      end
    end
  end
end
