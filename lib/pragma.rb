# frozen_string_literal: true

require 'pragma/operation'
require 'pragma/policy'
require 'pragma/contract'
require 'pragma/decorator'

require 'pragma/version'

require 'pragma/decorator/error'

require 'pragma/filter/base'
require 'pragma/filter/equals'
require 'pragma/filter/like'
require 'pragma/filter/ilike'
require 'pragma/filter/where'
require 'pragma/filter/scope'

require 'pragma/operation/filter'

require 'pragma/macro/classes'
require 'pragma/macro/decorator'
require 'pragma/macro/filtering'
require 'pragma/macro/ordering'
require 'pragma/macro/pagination'
require 'pragma/macro/policy'
require 'pragma/macro/model'
require 'pragma/macro/contract/build'
require 'pragma/macro/contract/validate'
require 'pragma/macro/contract/persist'

require 'pragma/operation/macro'

require 'pragma/operation/index'
require 'pragma/operation/show'
require 'pragma/operation/create'
require 'pragma/operation/update'
require 'pragma/operation/destroy'

# A pragmatic architecture for building JSON APIs.
#
# @author Alessandro Desantis
module Pragma
end
