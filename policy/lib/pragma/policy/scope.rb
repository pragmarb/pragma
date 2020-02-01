# frozen_string_literal: true

module Pragma
  module Policy
    # Authorizes AR scopes and other relations by only returning the records accessible by the
    # current user. Used, for instance, in index operations.
    class Scope
      # @!attribute [r] user
      #   @return [Object] the user accessing the records
      #
      # @!attribute [r] scope
      #   @return [Object] the relation to use as a base
      attr_reader :user, :scope
      alias context user

      # Initializes the scope.
      #
      # @param user [Object] the user accessing the records
      # @param scope [Object] the relation to use as a base
      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      # Returns the records accessible by the given user.
      #
      # @return [Object]
      #
      # @abstract Override to implement retrieving the accessible records
      def resolve
        fail NotImplementedError
      end

      private

      def policy_klass
        Object.const_get(self.class.name.split('::')[0..-2].join('::'))
      end
    end
  end
end
