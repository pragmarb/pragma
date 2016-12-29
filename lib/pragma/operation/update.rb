# frozen_string_literal: true
module Pragma
  module Operation
    # Finds the requested record, authorizes it, updates it accordingly to the parameters and
    # responds with the decorated record.
    #
    # @author Alessandro Desantis
    class Update < Pragma::Operation::Base
      include Pragma::Operation::Defaults

      def call
        record = find_record
        contract = build_contract(record)

        validate! contract
        authorize! contract

        contract.save

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
