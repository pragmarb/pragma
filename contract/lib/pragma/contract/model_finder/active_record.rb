# frozen_string_literal: true

module Pragma
  module Contract
    module ModelFinder
      class ActiveRecord < Base
        class << self
          def supports?(klass)
            defined?(::ActiveRecord::Base) && klass < ::ActiveRecord::Base
          end
        end

        def find(value)
          klass.find_by(options[:by] => value)
        end
      end
    end
  end
end
