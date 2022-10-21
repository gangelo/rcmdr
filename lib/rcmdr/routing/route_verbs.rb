# frozen_string_literal: true

require_relative '../errors/invalid_action_error'

module Rcmdr
  module Routing
    # This module provides methods for associating verbs
    # with controller actions.
    module RouteVerbs
      module_function

      def verbs_for(action:)
        case
        when action == :create
          [:post]
        when action == :destroy
          [:delete]
        when action == :update
          %i[put patch]
        when %i[edit index new show].include?(action)
          [:get]
        else
          raise Errors::InvalidActionError.new(action: action)
        end
      end
    end
  end
end