# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      # Links an association definition to a specific decorator instance, allowing to render it.
      #
      # @api private
      class Bond
        # @!attribute [r] reflection
        #   @return [Reflection] the association reflection
        #
        # @!attribute [r] decorator
        #   @return [Pragma::Decorator::Base] the decorator instance
        attr_reader :reflection, :decorator

        # Initializes the bond.
        #
        # @param reflection [Reflection] the association reflection
        # @param decorator [Pragma::Decorator::Base] the decorator instance
        def initialize(reflection:, decorator:)
          @reflection = reflection
          @decorator = decorator
        end

        # Returns the associated object.
        #
        # @return [Object]
        def associated_object
          case reflection.options[:exec_context]
          when :decorated
            model.public_send(reflection.attribute)
          when :decorator
            decorator.public_send(reflection.attribute)
          end
        end

        # Returns the unexpanded value for the associated object (i.e. its +id+ property).
        #
        # @return [String]
        def unexpanded_value
          adapter.primary_key
        end

        # Returns the expanded value for the associated object.
        #
        # If a decorator was specified for the association, first decorates the associated object,
        # then calls +#to_hash+ to render it as a hash.
        #
        # If no decorator was specified, calls +#as_json+ on the associated object.
        #
        # In any case, passes all nested associations as the +expand+ user option of the method
        # called.
        #
        # @param user_options [Array]
        #
        # @return [Hash]
        def expanded_value(user_options)
          full_object = adapter.full_object
          return unless full_object

          options = {
            user_options: user_options.merge(
              expand: flatten_expand(user_options[:expand])
            )
          }

          decorator_klass = compute_decorator

          if decorator_klass
            decorator_klass.new(full_object).to_hash(options)
          else
            full_object.as_json(options)
          end
        end

        # Renders the unexpanded or expanded associations, depending on the +expand+ user option
        # passed to the decorator.
        #
        # @param user_options [Array]
        #
        # @return [Hash|Pragma::Decorator::Base]
        def render(user_options)
          if user_options[:expand]&.any? { |value| value.to_s == reflection.name.to_s }
            expanded_value(user_options)
          else
            unexpanded_value
          end
        end

        # Returns the model associated to this bond.
        #
        # @return [Object]
        def model
          decorator.decorated
        end

        private

        def adapter
          @adapter ||= Adapter.load_adaptor(self)
        end

        def flatten_expand(expand)
          expand ||= []

          expected_beginning = "#{reflection.name}."

          expand.select { |value| value.start_with?(expected_beginning) }.map do |value|
            value.sub(expected_beginning, '')
          end
        end

        def compute_decorator
          if reflection.options[:decorator].respond_to?(:call)
            reflection.options[:decorator].call(associated_object)
          else
            reflection.options[:decorator]
          end
        end
      end
    end
  end
end
