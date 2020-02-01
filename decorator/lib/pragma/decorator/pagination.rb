# frozen_string_literal: true

module Pragma
  module Decorator
    # Pagination provides support for including pagination metadata in your collection.
    #
    # It is particularly useful when used in conjunction with {Collection}.
    #
    # It supports both {https://github.com/kaminari/kaminari Kaminari} and
    # {https://github.com/mislav/will_paginate will_paginate}.
    #
    # @example Including pagination metadata
    #   class ArticlesDecorator < Pragma::Decorator::Base
    #     include Pragma::Decorator::Collection
    #     include Pragma::Decorator::Pagination
    #   end
    #
    #   # {
    #   #   "data": [
    #   #     { "...": "..." },
    #   #     { "...": "..." },
    #   #     { "...": "..." }
    #   #   ],
    #   #   "total_entries": 150,
    #   #   "per_page": 30,
    #   #   "total_pages": 5,
    #   #   "previous_page": 2,
    #   #   "current_page": 3,
    #   #   "next_page": 4
    #   # }
    #   ArticlesDecorator.new(Article.all).to_hash
    module Pagination
      module InstanceMethods # :nodoc:
        # Returns the current page of the collection.
        #
        # @return [Integer] current page number
        #
        # @see Adapter::Base#current_page
        def current_page
          pagination_adapter.current_page
        end

        # Returns the next page of the collection.
        #
        # @return [Integer|NilClass] next page number, if any
        #
        # @see Adapter::Base#next_page
        def next_page
          pagination_adapter.next_page
        end

        # Returns the number of items per page in the collection.
        #
        # @return [Integer] items per page
        #
        # @see Adapter::Base#per_page
        def per_page
          pagination_adapter.per_page
        end

        # Returns the previous page of the collection.
        #
        # @return [Integer|NilClass] previous page number, if any
        #
        # @see Adapter::Base#previous_page
        def previous_page
          pagination_adapter.previous_page
        end

        # Returns the total number of items in the collection.
        #
        # @return [Integer] number of items
        #
        # @see Adapter::Base#total_entries
        def total_entries
          pagination_adapter.total_entries
        end

        # Returns the total number of pages in the collection.
        #
        # @return [Integer] number of pages
        #
        # @see Adapter::Base#total_pages
        def total_pages
          pagination_adapter.total_pages
        end

        private

        def pagination_adapter
          @pagination_adapter ||= Pagination::Adapter.load_adaptor(represented)
        end
      end

      def self.included(klass)
        klass.include InstanceMethods

        klass.class_eval do
          property :total_entries, exec_context: :decorator
          property :per_page, exec_context: :decorator
          property :total_pages, exec_context: :decorator
          property :previous_page, exec_context: :decorator
          property :current_page, exec_context: :decorator
          property :next_page, exec_context: :decorator
        end
      end
    end
  end
end
