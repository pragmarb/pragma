# frozen_string_literal: true

require 'trailblazer/operation/model'

module Pragma
  module Operation
    module Macro
      def self.Model(action = nil)
        step = lambda do |input, options|
          Trailblazer::Operation::Pipetree::Step.new(
            Trailblazer::Operation::Model.for(options['model.class'], action),
            'model.class' => options['model.class'],
            'model.action' => action
          ).call(input, options)
        end

        [step, name: 'model.build']
      end
    end
  end
end
