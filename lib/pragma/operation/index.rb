module Pragma
  module Operation
    class Index < Pragma::Operation::Base
      include Pragma::Operation::Awareness

      def call
        records = authorize_collection(find_records)
        respond_with status: :ok, resource: decorate(records)
      end

      private

      def find_records
        self.class.model_klass.all
      end
    end
  end
end
