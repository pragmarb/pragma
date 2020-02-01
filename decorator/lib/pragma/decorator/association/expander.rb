# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      module Expander
        include Adaptor::Loader
        register ActiveRecord, Poro
      end
    end
  end
end
