# frozen_string_literal: true

require 'trailblazer/operation/persist'

module Pragma
  module Operation
    module Macro
      module Contract
        def self.Persist(**args)
          step = lambda do |input, options|
            Trailblazer::Operation::Pipetree::Step.new(
              Trailblazer::Operation::Contract::Persist(**args).first
            ).call(input, options).tap do |result|
              unless result
                options['result.response'] = Pragma::Operation::Response::UnprocessableEntity.new(
                  errors: options['model'].errors.messages
                ).decorate_with(Pragma::Decorator::Error)
              end
            end
          end

          [step, name: 'persist.save']
        end
      end
    end
  end
end
