# frozen_string_literal: true

module Pragma
  module AssociationIncluder
    include Adaptor::Loader
    register ActiveRecord, Poro
  end
end
