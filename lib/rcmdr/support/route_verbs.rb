# frozen_string_literal: true

require_relative '../errors/invalid_action_error'

module Rcmdr
  module Support
    # This module provides methods for associating verbs
    # with controller actions.
    module RouteVerbs
      module_function

      def verb_for(action:)
        case action
        when :create
          :post
        when :destroy
          :delete
        when :edit
          :get
        when :index
          :get
        when :new
          :get
        when :show
          :get
        when :update
          :put
        else
          raise Errors::InvalidActionError.new(action: action)
        end
      end
    end
  end
end
