# frozen_string_literal: true
module Pragma
  module Operation
    # Finds the requested record, authorizes it and decorates it.
    #
    # @author Alessandro Desantis
    class Show < Pragma::Operation::Base
      include Pragma::Operation::Defaults

      def call
        record = find_record
        authorize! record

        respond_with resource: decorate(record)
      end

      protected

      # Finds the requested record.
      #
      # @return [Object]
      def find_record
        self.class.model_klass.find(params[:id])
      end
    end
  end
end
