# frozen_string_literal: true

require 'pragma/operation'
require 'pragma/policy'
require 'pragma/contract'
require 'pragma/decorator'

require 'will_paginate'
require 'will_paginate/array'

require 'pragma/version'

require 'pragma/decorator/error'

require 'pragma/operation/filter/base'
require 'pragma/operation/filter/equals'
require 'pragma/operation/filter/like'
require 'pragma/operation/filter/ilike'

require 'pragma/operation/macro/classes'
require 'pragma/operation/macro/decorator'
require 'pragma/operation/macro/filtering'
require 'pragma/operation/macro/ordering'
require 'pragma/operation/macro/pagination'
require 'pragma/operation/macro/policy'
require 'pragma/operation/macro/model'
require 'pragma/operation/macro/contract/build'
require 'pragma/operation/macro/contract/validate'
require 'pragma/operation/macro/contract/persist'

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
