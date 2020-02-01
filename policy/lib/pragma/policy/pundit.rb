# frozen_string_literal: true

module Pragma
  module Policy
    # Provides a simple way for Pragma policies to delegate to Pundit policies/scopes.
    #
    # @example
    #   class API::V1::Article::Policy < Pragma::Policy::Pundit
    #     # The default would be ArticlePolicy.
    #     self.pundit_klass = CustomArticlePolicy
    #   end
    class Pundit < Base
      class << self
        attr_writer :pundit_klass

        def pundit_klass
          @pundit_klass ||= Object.const_get("#{self.class.name.split('::')[-2]}Policy")
        end

        def inherited(base)
          base.class_eval <<~RUBY, __FILE__, __LINE__ + 1
            class Scope < Pragma::Policy::Scope
              def initialize(user, scope)
                super
                @pundit_scope = pundit_scope_klass.new(user, scope)
              end

              def resolve
                @pundit_scope.resolve
              end

              private

              def pundit_scope_klass
                policy_klass.pundit_klass.const_get('Scope')
              end
            end
          RUBY
        end
      end

      def initialize(user, record)
        super
        @pundit_policy = self.class.pundit_klass.new(user, record)
      end

      def respond_to_missing?(method_name, include_private = false)
        super || @pundit_policy.respond_to?("#{method_name[0..-2]}?", include_private)
      end

      def method_missing(method_name, *args, &block)
        return super unless @pundit_policy.respond_to?(method_name)

        @pundit_policy.send(method_name, *args, &block)
      end
    end
  end
end
