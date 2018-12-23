# frozen_string_literal: true

module Pragma
  module Macro
    class << self
      def require_skill(macro, skill, options)
        fail MissingSkillError.new(macro, skill) unless options[skill]
      end
    end

    class MissingSkillError < StandardError
      def initialize(macro, missing_skill)
        message = <<~ERROR
          You are attempting to use the #{macro} macro, but no `#{missing_skill}` skill is defined.

          This can happen when a required class (e.g. the contract class) is not in the expected
          location.

          To solve the problem, move the class to its expected location or, if you want to provide
          the class manually, add the following to your operation:

            self['#{missing_skill}'] = MyCustomClass

          If you don't have the class you will have to skip the macro that requires it.
        ERROR

        super message
      end
    end
  end
end
