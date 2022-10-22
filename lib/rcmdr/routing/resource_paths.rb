# frozen_string_literal: true

require_relative '../errors/invalid_action_error'

module Rcmdr
  module Routing
    # This module provides methods for constructing resource
    # paths given a resource and a controller action.
    module ResourcePaths
      module_function

      def resource_path_for(resource, action:)
        if %i[create index].include?(action)
          "/#{resource}"
        elsif action == :edit
          "/#{resource}/:id/edit"
        elsif action == :new
          "/#{resource}/new"
        elsif %i[destroy show update].include?(action)
          "/#{resource}/:id"
        else
          raise Rcmdr::Errors::InvalidActionError.new(action:)
        end
      end
    end
  end
end
