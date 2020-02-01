# frozen_string_literal: true

module Pragma
  module Resource
    module Macro
      class << self
        # Returns a skill or raises a {#MissingSkillError}.
        #
        # @param macro [String] the name of the macro requiring the skill
        # @param skill [String] the name of the string
        # @param options [Hash] the +options+ hash of the operation
        #
        # @return [Object] the value of the skill
        #
        # @raise [MissingSkillError] if the skill is undefined or +nil+
        #
        # @private
        def require_skill(macro, skill, options)
          options[skill] || fail(MissingSkillError.new(macro, skill))
        end

        def Model(action = nil)
          step = lambda do |input, options|
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

          [step, name: "model.#{action || 'build'}"]
        end

        def Classes
          step = ->(input, options) { Classes.for(input, options) }
          [step, name: 'classes']
        end

        def Policy(name: :default, action: nil)
          step = ->(input, options) { Policy.for(input, name, options, action) }
          [step, name: "policy.#{name}"]
        end

        def Pagination
          step = ->(input, options) { Pagination.for(input, options) }
          [step, name: 'pagination']
        end

        def Ordering
          step = ->(input, options) { Ordering.for(input, options) }
          [step, name: 'ordering']
        end

        def Decorator(name: :instance)
          step = ->(input, options) { Decorator.for(input, name, options) }
          [step, name: "decorator.#{name}"]
        end
      end

      # Error raised when a skill is required but not present.
      #
      # @private
      class MissingSkillError < StandardError
        # Initializes the error.
        #
        # @param macro [String] the macro requiring the skill
        # @param skill [String] the name of the missing skill
        def initialize(macro, skill)
          message = <<~ERROR
            You are attempting to use the #{macro} macro, but no `#{skill}' skill is defined.

            You can define the skill by adding the following to your operation:

              self['#{skill}'] = MyCustomClass

            If the skill holds a class, this can happen when the required class (e.g. the contract
            class) is not in the expected location. If that's the case, you can just move the class to
            the expected location and avoid defining the skill manually.
          ERROR

          super message
        end
      end
    end
  end
end
