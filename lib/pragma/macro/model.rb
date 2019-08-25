# frozen_string_literal: true

module Pragma
  module Macro
    module Model
      class << self
        def for(input, options)
          klass = Macro.require_skill('Model', 'model.class', options)

          Trailblazer::Operation::Pipetree::Step.new(
            Trailblazer::Operation::Model.for(klass, action),
            'model.class' => klass,
            'model.action' => action
          ).call(input, options).tap do |result|
            unless result
              options['result.response'] = Pragma::Operation::Response::NotFound.new.decorate_with(
                Pragma::Decorator::Error
              )
            end
          end
        end
      end
    end
  end
end
