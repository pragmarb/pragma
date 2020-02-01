# frozen_string_literal: true

module Pragma
  module Decorator
    module Association
      module Expander
        class ActiveRecord < Base
          class << self
            def supports?(relation)
              defined?(::ActiveRecord::Relation) && relation.is_a?(::ActiveRecord::Relation)
            end
          end

          def include_associations(expands)
            relation.includes(validate_associations(
                                relation.model,
                                destruct_associations(expands)
                              ))
          end

          private

          def destruct_associations(expands)
            associations = {}

            expands.each do |expand|
              expand.split('.').inject(associations) do |accumulator, association|
                accumulator[association] ||= {}
              end
            end

            associations
          end

          def validate_associations(model, associations)
            Hash[associations.map do |(key, value)|
              reflection = model.reflect_on_association(key.to_sym)
              reflection ? [key, validate_associations(reflection.klass, value)] : [false, false]
            end.select { |_, v| v }]
          end
        end
      end
    end
  end
end
