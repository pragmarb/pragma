# frozen_string_literal: true
module Pragma
  module Operation
    # Finds the requested record, authorizes it, updates it accordingly to the parameters and
    # responds with the decorated record.
    #
    # @author Alessandro Desantis
    class Create < Pragma::Operation::Base
      include Pragma::Operation::Defaults

      def call
        record = build_record
        contract = build_contract(record)

        validate! contract
        authorize! contract

        contract.save

        respond_with resource: decorate(record)
      end

      protected

      # Builds the requested record.
      #
      # @return [Object]
      def build_record
        self.class.model_klass.new
      end
    end
  end
end
