# frozen_string_literal: true

module Pragma
  module Decorator
    # This module is used to represent collections of objects.
    #
    # It will wrap the collection in a +data+ property so that you can include meta-data about the
    # collection at the root level.
    #
    # @example Using Collection to include a total count
    #   class ArticlesDecorator < Pragma::Decorator::Base
    #     include Pragma::Decorator::Collection
    #
    #     property :total_count, exec_context: :decorator
    #
    #     def total_count
    #       represented.count
    #     end
    #   end
    #
    #   # {
    #   #   "data": [
    #   #     { "...": "..." },
    #   #     { "...": "..." },
    #   #     { "...": "..." }
    #   #   ],
    #   #   "total_count": 150
    #   # }
    #   ArticlesDecorator.new(Article.all).to_hash
    module Collection
      def self.included(klass)
        klass.include InstanceMethods
        klass.extend ClassMethods

        klass.class_eval do
          collection :data, exec_context: :decorator, getter: (lambda do |options:, **|
            represented_collection = if self.class.instance_decorator.is_a?(Proc)
                                       represented.map do |item|
                                         self.class.instance_decorator.call(item).represent(item).to_hash(options)
                                       end
                                     elsif self.class.instance_decorator
                                       self.class.instance_decorator.represent(represented.to_a).to_hash(options)
                                     else
                                       represented
            end
            represented_collection
          end)
        end
      end

      module InstanceMethods # :nodoc:
        # Overrides the type of the resource to be +list+, for compatibility with {Type}.
        #
        # @see Type
        def type
          'list'
        end
      end

      module ClassMethods # :nodoc:
        # Defines the decorator to use for each resource in the collection.
        #
        # @param decorator [Class|Proc] a decorator class, or a callable accepting a represented
        #   object as argument and returning a decorator class
        def decorate_with(decorator)
          @instance_decorator = decorator
        end

        # Returns the instance decorator for this collection.
        #
        # If no decorator was set manually with {#decorate_with}, this assumes the decorator is in
        # the same namespace as the current class and is called +Instance+.
        #
        # @return [Class\Proc] the instance decorator to use
        def instance_decorator
          @instance_decorator ||= Object.const_get((
            name.split('::')[0..-2] + ['Instance']
          ).join('::'))
        end
      end
    end
  end
end
