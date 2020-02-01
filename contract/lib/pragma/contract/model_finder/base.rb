# frozen_string_literal: true

module Pragma
  module Contract
    module ModelFinder
      class Base
        include Adaptor

        class << self
          def supports?(_klass)
            fail NotImplementedError
          end
        end

        attr_reader :klass, :options

        def initialize(klass, options)
          @klass = klass
          @options = { by: :id }.merge(options)
        end

        def find(_value)
          fail NotImplementedError
        end
      end
    end
  end
end
