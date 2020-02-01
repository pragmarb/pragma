# frozen_string_literal: true

require 'json'
require 'trailblazer/operation'
require 'zeitwerk'

Zeitwerk::Loader.new.tap do |loader|
  loader.tag = File.basename(__FILE__, '.rb')
  loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
  loader.push_dir(File.expand_path('..', __dir__))
  loader.setup
end

module Pragma
  # Operations provide business logic encapsulation for your JSON API.
  #
  # @author Alessandro Desantis
  module Operation
  end
end
