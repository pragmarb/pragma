module Pragma
  module Operation
    class Index < Pragma::Operation::Base
      include Pragma::Operation::Awareness

      def call
        records = authorize_collection(find_records)
        records = records.paginate(page: page, per_page: per_page)

        respond_with(
          status: :ok,
          resource: decorate(records),
          headers: {
            'Page' => records.current_page.to_i,
            'Per-Page' => records.per_page,
            'Total' => records.total_entries
          }
        )
      end

      protected

      def find_records
        self.class.model_klass.all
      end

      def page
        params[:page]
      end

      def per_page
        30
      end
    end
  end
end
