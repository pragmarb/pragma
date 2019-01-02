# frozen_string_literal: true

require 'trailblazer/operation/persist'

module Pragma
  module Macro
    module Contract
      def self.Persist(method: :save, name: 'default')
        step = lambda do |input, options|
          Macro.require_skill('Contract::Persist', "contract.#{name}.class", options)

          Trailblazer::Operation::Pipetree::Step.new(
            Trailblazer::Operation::Contract::Persist(method: method, name: name).first
          ).call(input, options).tap do |result|
            unless result
              options['result.response'] = Pragma::Operation::Response::UnprocessableEntity.new(
                errors: options["contract.#{name}"].model.errors.messages
              ).decorate_with(Pragma::Decorator::Error)
            end
          end
        end

        [step, name: "contract.#{name}.#{method}"]
      end
    end
  end
end
