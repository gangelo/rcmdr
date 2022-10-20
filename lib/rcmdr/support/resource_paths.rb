# frozen_string_literal: true

require_relative '../errors/invalid_action_error'

module Rcmdr
  module Support
    # This module provides methods for constructing resource
    # paths given a resource and a controller action.
    module ResourcePaths
      module_function

      def resource_path_for(resource, action:)
        case action
        when :create
          "/#{resource}"
        when :destroy
          "/#{resource}/:id"
        when :edit
          "/#{resource}/:id/edit"
        when :index
          "/#{resource}"
        when :new
          "/#{resource}/new"
        when :show
          "/#{resource}/:id"
        when :update
          "/#{resource}/:id"
        else
          raise Rcmdr::Errors::InvalidActionError.new(action: action)
        end
      end
    end
  end
end
