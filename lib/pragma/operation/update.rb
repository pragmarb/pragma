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
        context.record = find_record
        context.contract = build_contract(context.record)

        validate! context.contract
        authorize! context.contract

        context.contract.save do |hash|
          context.record.update! hash
        end

        respond_with resource: decorate(context.record)
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
