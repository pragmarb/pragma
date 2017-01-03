# frozen_string_literal: true
module Pragma
  module Operation
    # Finds all records of the requested resource, authorizes them, paginates them and returns
    # the decorated collection.
    #
    # @author Alessandro Desantis
    class Index < Pragma::Operation::Base
      include Pragma::Operation::Defaults

      def call
        records = authorize_collection(find_records)
        records = records.paginate(page: page, per_page: per_page)

        respond_with(
          resource: decorate(records),
          headers: {
            'Page' => records.current_page.to_i,
            'Per-Page' => records.per_page,
            'Total' => records.total_entries
          },
          links: {
            first: build_page_url(1),
            last: build_page_url(records.total_pages),
            next: (build_page_url(records.next_page) if records.next_page),
            prev: (build_page_url(records.previous_page) if records.previous_page)
          }
        )
      end

      protected

      # Finds all the records. By default, calls +.all+ on the model class, which is inferred from
      # the operation's namespace (e.g. +API::V1::Post::Operation::Index+ will retrieve all records
      # of the +Post+ model).
      #
      # @return [Enumerable]
      def find_records
        self.class.model_klass.all
      end

      # Returns the name of the page parameter.
      #
      # @return [Symbol]
      def page_param
        :page
      end

      # Returns the page number. By default, this is the page parameter or 1 if it is empty.
      #
      # @return [Fixnum]
      #
      # @see #page_param
      def page
        return 1 if !params[page_param] || params[page_param].empty?
        params[page_param].to_i
      end

      # Returns the name of the per_page param.
      #
      # @return [Symbol]
      def per_page_param
        :per_page
      end

      # Returns the default number of records per page.
      #
      # @return [Fixnum]
      def default_per_page
        30
      end

      # Returns the maximum number of records per page.
      #
      # @return [Fixnum]
      def max_per_page
        100
      end

      # Returns the number of records to include per page. By default, this is the +per_page+
      # parameter, up to a maximum of {#max_per_page} records, or {#default_per_page} if the
      # parameter is not present.
      #
      # @return [Fixnum]
      #
      # @see #default_per_page
      # @see #max_per_page
      # @see #per_page_param
      def per_page
        return default_per_page if !params[per_page_param] || params[per_page_param].empty?
        params[per_page_param].to_i > max_per_page ? max_per_page : params[per_page_param].to_i
      end

      # Builds the URL to a specific page in the collection.
      #
      # @param page [Fixnum] a page number
      #
      # @return [String]
      def build_page_url(_page)
        nil
      end
    end
  end
end
