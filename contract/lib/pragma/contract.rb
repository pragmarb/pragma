# frozen_string_literal: true

require 'adaptor'
require 'dry-validation'
require 'dry-types'
require 'reform'
require 'zeitwerk'

Zeitwerk::Loader.new.tap do |loader|
  loader.tag = File.basename(__FILE__, '.rb')
  loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
  loader.push_dir(File.expand_path('..', __dir__))
  loader.setup
end

module Pragma
  # Form objects on steroids for your HTTP API.
  module Contract
  end
end
