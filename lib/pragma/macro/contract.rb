# frozen_string_literal: true

require 'trailblazer/operation/contract'
require 'trailblazer/operation/persist'
require 'trailblazer/operation/validate'

module Pragma
  module Macro
    module Contract
      def self.Build(name: 'default', constant: nil, builder: nil)
        step = lambda do |input, options|
          Macro.require_skill('Contract::Build', "contract.#{name}.class", options)

          Trailblazer::Operation::Contract::Build.for(
            input,
            options,
            name: name,
            constant: constant,
            builder: builder
          ).tap do |contract|
            contract.current_user = options['current_user']
          end
        end

        [step, name: "contract.#{name}.build"]
      end

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

      def self.Validate(name: 'default', **args)
        step = lambda do |input, options|
          Macro.require_skill('Contract::Validate', "contract.#{name}.class", options)

          Trailblazer::Operation::Pipetree::Step.new(
            Trailblazer::Operation::Contract::Validate(**args).first
          ).call(input, options).tap do |result|
            unless result
              options['result.response'] = Pragma::Operation::Response::UnprocessableEntity.new(
                errors: options["contract.#{name}"].errors.messages
              ).decorate_with(Pragma::Decorator::Error)
            end
          end
        end

        [step, name: "contract.#{name}.validate"]
      end
    end
  end
end
