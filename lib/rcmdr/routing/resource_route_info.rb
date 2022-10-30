# frozen_string_literal: true

require_relative '../validators/action_validator'
require_relative '../validators/verb_validator'

module Rcmdr
  module Routing
    class ResourceRouteInfo
      include Rcmdr::Validators::ActionValidator
      include Rcmdr::Validators::VerbValidator

      attr_reader :resource, :verb, :action, :options

      def initialize(resource, verb:, action:, **options)
        # TODO: Validate options

        resource = resource.to_sym
        verb = verb.to_sym
        action = action.to_sym

        validate_verb! verb
        validate_action! action

        @resource = resource
        @verb = verb
        @action = action
        @options = options
      end

      def resource_singular
        @resource_singular ||= resource.to_s.singularize
      end

      def resource_plural
        @resource_plural ||= resource.to_s.pluralize
      end

      def prefix
        @prefix ||= if %i[index create].include?(action)
          resource_plural
        elsif action == :new
          "new_#{resource_singular}"
        elsif action == :edit
          "edit_#{resource_singular}"
        else
          # action == :show, :update, :destroy
          resource_singular
        end
      end

      def uri_pattern
        @uri_pattern ||= if %i[index create].include?(action)
          "/#{resource_plural}"
        elsif action == :new
          "/#{resource_plural}/new"
        elsif action == :edit
          "/#{resource_plural}/:id/edit"
        else
          # action == :show, :update, :destroy
          "/#{resource_plural}/:id"
        end
      end
      alias path uri_pattern

      def controller_action
        @controller_action ||= if %i[index create].include?(action)
          "/#{resource_plural}"
        elsif action == :new
          "/#{resource_plural}/new"
        elsif action == :edit
          "/#{resource_plural}/:id/edit"
        else
          # action == :show, :update, :destroy
          "/#{resource_plural}/:id"
        end
      end
    end
  end
end
