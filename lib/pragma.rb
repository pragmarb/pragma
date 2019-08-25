# frozen_string_literal: true

require 'adaptor'
require 'pragma/operation'
require 'pragma/policy'
require 'pragma/contract'
require 'pragma/decorator'
require 'zeitwerk'

Zeitwerk::Loader.for_gem.setup

# A pragmatic architecture for building JSON APIs.
#
# @author Alessandro Desantis
module Pragma
end
