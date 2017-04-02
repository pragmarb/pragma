# frozen_string_literal: true
require 'pragma/operation'
require 'pragma/policy'
require 'pragma/contract'
require 'pragma/decorator'

require 'will_paginate'
require 'will_paginate/array'

require 'pragma/version'

require 'pragma/decorator/error'

require 'pragma/operation/macro/classes'
require 'pragma/operation/macro/decorator'
require 'pragma/operation/macro/pagination'
require 'pragma/operation/macro/policy'
require 'pragma/operation/macro/model'

require 'pragma/operation/response/not_found'
require 'pragma/operation/response/forbidden'
require 'pragma/operation/response/unprocessable_entity'
require 'pragma/operation/response/created'
require 'pragma/operation/response/ok'

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
