# frozen_string_literal: true

module Pragma
  module Decorator
    # Associations provide a way to define related records on your decorators.
    #
    # Once you define an association, it can be expanded by API clients through the +expand+ query
    # parameter to load the full record.
    #
    # @example Defining and expanding an association
    #   class ArticleDecorator < Pragma::Decorator::Base
    #     belongs_to :author, decorator: API::V1::User::Decorator
    #   end
    #
    #   # This will return a hash whose `author` key is the ID of the article's author.
    #   ArticleDecorator.new(article).to_hash
    #
    #   # This will return a hash whose `author` key is a hash representing the decorated
    #   # article's author.
    #   ArticleDecorator.new(article).to_hash(user_options: { expand: ['author'] })
    module Association
      def self.included(klass)
        klass.extend ClassMethods
        klass.include InstanceMethods
      end

      module ClassMethods # :nodoc:
        # Returns the associations defined on this decorator.
        #
        # @return [Hash{Symbol => Reflection}] the associations
        def associations
          @associations ||= superclass.respond_to?(:associations) ? superclass.associations : {}
        end

        # Defines a +belongs_to+ association on this decorator.
        #
        # This will first create an association definition and then define a new property with the
        # name of the association.
        #
        # This method supports all the usual options accepted by +#property+.
        #
        # @param attribute_name [Symbol] name of the association
        # @param options [Hash] the association's options
        def belongs_to(attribute_name, options = {})
          define_association :belongs_to, attribute_name, options
        end

        # Defines a +has_one+ association on this decorator.
        #
        # This will first create an association definition and then define a new property with the
        # name of the association.
        #
        # This method supports all the usual options accepted by +#property+.
        #
        # @param attribute_name [Symbol] name of the association
        # @param options [Hash] the association's options
        def has_one(attribute_name, options = {}) # rubocop:disable Naming/PredicateName
          define_association :has_one, attribute_name, options
        end

        private

        def define_association(type, attribute_name, options = {})
          create_association_definition(type, attribute_name, options)
          create_association_property(attribute_name, options)
        end

        def create_association_definition(type, attribute_name, options)
          association_name = options.fetch(:as, attribute_name.to_sym)
          associations[association_name] = Reflection.new(options.merge(
                                                            type: type,
                                                            name: association_name,
                                                            attribute: attribute_name
                                                          ))
        end

        def create_association_property(attribute_name, options)
          association_name = options.fetch(:as, attribute_name.to_sym)

          property_options = options.dup.tap { |po| po.delete(:decorator) }.merge(
            exec_context: :decorator,
            as: options[:as] || attribute_name,
            getter: (lambda do |decorator:, user_options:, **_args|
              Bond.new(
                reflection: decorator.class.associations[association_name],
                decorator: decorator
              ).render(user_options)
            end)
          )

          property("_#{association_name}_association", property_options)
        end
      end

      module InstanceMethods # :nodoc:
        def validate_expansion(expand)
          check_parent_associations_are_expanded(expand)
          check_expanded_associations_exist(expand)
        end

        private

        def check_parent_associations_are_expanded(expand)
          expand = normalize_expand(expand)

          expand.each do |property|
            next unless property.include?('.')

            parent_path = property.split('.')[0..-2].join('.')
            next if expand.include?(parent_path)

            fail Association::UnexpandedAssociationParent.new(property, parent_path)
          end
        end

        def check_expanded_associations_exist(expand)
          expand = normalize_expand(expand)

          expand.each do |property|
            next if self.class.associations.key?(property.to_sym) || property.include?('.')

            fail Association::AssociationNotFound, property
          end
        end

        def normalize_expand(expand)
          [expand].flatten.map(&:to_s).reject(&:blank?)
        end
      end
    end
  end
end
