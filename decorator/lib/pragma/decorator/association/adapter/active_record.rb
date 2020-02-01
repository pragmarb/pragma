# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      module Adapter
        # The ActiveRecord association adapter is used in AR environments and tries to minimize the
        # number of SQL queries that are made to retrieve the associated object's data.
        #
        # @api private
        class ActiveRecord < Base
          include Adaptor

          class << self
            # Returns whether the adapter supports the given bond.
            #
            # @param bond [Bond] the bond to check
            #
            # @return [Boolean] whether the object is an instance of +ActiveRecord::Base+
            def supports?(bond)
              Object.const_defined?('::ActiveRecord::Base') &&
                bond.model.is_a?(::ActiveRecord::Base)
            end
          end

          # Initializes the adapter.
          #
          # @param bond [Bond] the bond to use in the adapter
          #
          # @raise [InconsistentTypeError] when the association's real type is different from the
          #   one defined on the decorator ()e.g. decorator defines the association as +belongs_to+,
          #   but ActiveRecord reports its type is +has_one+)
          def initialize(bond)
            super
            check_type_consistency
          end

          # Returns the primary key of the associated object.
          #
          # If the +exec_context+ of the association is +decorator+, this will simply return early
          # with the value returned by +#id+ on the associated object.
          #
          # If the association is a +belongs_to+, there are three possible scenarios:
          #
          #   * the association does not have a custom scope: this will compute the PK by calling
          #     the foreign key on the parent model;
          #   * the association has a custom scope and it has not been loaded: this will compute
          #     the PK by +pluck+ing the PK column of the associated object;
          #   * the association has a custom scope and it has been loaded: this will compute
          #     the PK by retrieving the PK attribute from the loaded object.
          #
          # If the association is a +has_one+, there are two possible scenarios:
          #
          #   * the association has already been loaded: this will compute the PK by retrieving the
          #     PK attribute from the loaded object;
          #   * the association has not been loaded: this will compute the PK by +pluck+ing the PK
          #     column of the associated object;
          #
          # Custom scopes are always respected in both +belongs_to+ and +has_one+.
          #
          # +nil+ values are handled gracefully in all cases.
          #
          # @return [String|Integer|NilClass] the PK of the associated object
          #
          # @todo Allow to specify a different PK attribute when +exec_context+ is +decorator+
          def primary_key
            return associated_object&.id if association_reflection.nil? ||
                                            reflection.options[:exec_context] == :decorator

            case reflection.type
            when :belongs_to
              compute_belongs_to_fk
            when :has_one
              compute_has_one_fk
            else
              fail "Cannot compute primary key for #{reflection.type} association"
            end
          end

          # Returns the expanded associated object.
          #
          # This will simply return the associated object itself, delegating caching to AR.
          #
          # @return [Object] the associated object
          #
          # @todo Ensure the required attributes are present on the associated object
          def full_object
            associated_object
          end

          private

          def compute_belongs_to_fk
            primary_key = if association_reflection.polymorphic?
                            association_reflection.options[:primary_key] || associated_object.class.primary_key
                          else
                            association_reflection.association_primary_key
            end

            if model.association(reflection.attribute).loaded?
              return associated_object&.public_send(primary_key)
            end

            if association_reflection.scope.nil?
              return model.public_send(association_reflection.foreign_key)
            end

            pluck_association_fk do |scope|
              fk = model.public_send(association_reflection.foreign_key)
              scope.where(primary_key => fk)
            end
          end

          def compute_has_one_fk
            if model.association(reflection.attribute).loaded?
              return associated_object&.public_send(association_reflection.association_primary_key)
            end

            pluck_association_fk do |scope|
              pk = model.public_send(association_reflection.active_record_primary_key)
              scope.where(association_reflection.foreign_key => pk)
            end
          end

          def pluck_association_fk
            scope = association_reflection.klass.all

            if association_reflection.scope
              scope = scope.instance_eval(&association_reflection.scope)
            end

            yield(scope).pluck(association_reflection.association_primary_key).first
          end

          def association_reflection
            @association_reflection ||= model.class.reflect_on_association(reflection.attribute)
          end

          def check_type_consistency
            return unless association_reflection
            return if association_reflection.macro.to_sym == reflection.type.to_sym

            fail InconsistentTypeError.new(
              decorator: decorator,
              reflection: reflection,
              model_type: association_reflection.macro
            )
          end
        end
      end
    end
  end
end
