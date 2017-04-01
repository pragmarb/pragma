require 'coveralls'
Coveralls.wear!

require 'pry'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pragma'

module API
  module V1
    module Post
      class Decorator < Pragma::Decorator::Base
        property :title
      end
    end
  end
end
