# frozen_string_literal: true

require 'zeitwerk'

Zeitwerk::Loader.new.tap do |loader|
  loader.tag = File.basename(__FILE__, '.rb')
  loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
  loader.push_dir(File.expand_path('..', __dir__))
  loader.setup
end

module Pragma
  # Fine-grained access control for your API resources.
  module Policy
  end
end
