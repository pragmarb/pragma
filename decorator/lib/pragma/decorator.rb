# frozen_string_literal: true

require 'adaptor'
require 'roar'
require 'zeitwerk'

Zeitwerk::Loader.new.tap do |loader|
  loader.tag = File.basename(__FILE__, '.rb')
  loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
  loader.push_dir(File.expand_path('..', __dir__))
  loader.setup
end

module Pragma
  # Represent your API resources in JSON with minimum hassle.
  module Decorator
  end
end
