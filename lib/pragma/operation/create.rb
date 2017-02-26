# frozen_string_literal: true
module Pragma
  module Operation
    # Finds the requested record, authorizes it, updates it accordingly to the parameters and
    # responds with the decorated record.
    #
    # @author Alessandro Desantis
    class Create < Pragma::Operation::Base
      # include Pragma::Operation::Defaults

      def call
        context.record = build_record
        context.contract = build_contract(context.record)

        validate! context.contract
        authorize! context.contract

        context.contract.save
        context.record.save!

        respond_with status: :created, resource: decorate(context.record)
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
