# frozen_string_literal: true

module Pragma
  module Decorator
    # Adds a +type+ property containing the machine-readable type of the represented object.
    #
    # This is useful for the client to understand what kind of resource it's dealing with
    # and trigger related logic.
    #
    # @example Including the resource's type
    #   class ArticleDecorator < Pragma::Decorator::Base
    #     include Pragma::Decorator::Type
    #   end
    #
    #   # {
    #   #   "type": "article"
    #   # }
    #   ArticleDecorator.new(article).to_hash
    module Type
      class << self
        def included(klass)
          klass.class_eval do
            property :type, exec_context: :decorator, render_nil: false
          end
        end

        # Returns the type overrides.
        #
        # By default, +Array+ and +ActiveRecord::Relation+ are renamed to +list+.
        #
        # @return [Hash{String => String}] a hash of class-override pairs
        def overrides
          @overrides ||= {
            'Array' => 'list',
            'ActiveRecord::Relation' => 'list'
          }
        end
      end

      # Returns the type to expose to API clients.
      #
      # If an override is present for the decorated class, returns the override, otherwise returns
      # the underscored class.
      #
      # @return [String] type to expose
      #
      # @see .overrides
      def type
        Pragma::Decorator::Type.overrides[decorated.class.name] ||
          underscore_klass(decorated.class.name)
      end

      private

      def underscore_klass(klass)
        klass
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .gsub('::', '/')
          .downcase
      end
    end
  end
end
