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

      # Returns the current page number. By default, this is the +page+ parameter or 1 if the
      # parameter is not present.
      #
      # @return [Fixnum]
      def page
        return 1 if !params[:page] || params[:page].empty?
        params[:page].to_i
      end

      # Returns the number of records to include per page. By default, this is the +per_page+
      # parameter, up to a maximum of {#max_per_page} records, or {#default_per_page} if the
      # parameter is not present.
      #
      # @return [Fixnum]
      #
      # @see #default_per_page
      # @see #max_per_page
      def per_page
        return default_per_page if !params[:per_page] || params[:per_page].empty?
        params[:per_page].to_i > max_per_page ? max_per_page : params[:per_page].to_i
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
    end
  end
end
