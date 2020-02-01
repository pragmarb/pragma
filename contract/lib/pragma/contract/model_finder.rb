# frozen_string_literal: true

module Pragma
  module Contract
    module ModelFinder
      include Adaptor::Loader
      register ActiveRecord

      FINDER_OPTIONS = [:by].freeze

      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        def property(name, options = {})
          return super if !options[:type] || options[:type].is_a?(Dry::Types::Type)

          property(name, Hash[options.reject { |k, _| k == :type }])

          define_method("#{name}=") do |value|
            finder = Pragma::Contract::ModelFinder.load_adaptor!(
              options[:type],
              Hash[options.select { |k, _| FINDER_OPTIONS.include?(k.to_sym) }]
            )

            super finder.find(value)
          end
        end
      end
    end
  end
end
