# frozen_string_literal: true

require_relative '../errors/invalid_action_error'

module Rcmdr
  module Routing
    # This module provides methods for constructing resource
    # paths given a resource and a controller action.
    module ResourcePaths
      module_function

      def resource_path_for(resource, action:)
        case
        when action == :create || action == :index
          "/#{resource}"
        when action == :edit
          "/#{resource}/:id/edit"
        when action == :new
          "/#{resource}/new"
        when %i[destroy show update].include?(action)
          "/#{resource}/:id"
        else
          raise Rcmdr::Errors::InvalidActionError.new(action: action)
        end
      end
    end
  end
end
