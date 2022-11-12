# frozen_string_literal: true

require_relative '../validators/action_validator'
require_relative '../validators/verb_validator'
require_relative 'namespaces'

module Rcmdr
  module Routing
    class ResourceRouteInfo
      include Rcmdr::Validators::ActionValidator
      include Rcmdr::Validators::VerbValidator
      include Namespaces

      attr_reader :resource, :verb, :action, :options

      def initialize(resource, verb:, action:, **options)
        unless [String, Symbol].any? { |kind| resource.is_a?(kind) }
          raise 'Resource is invalid. Expected String or Symbol, ' \
                "but recieved \"#{resource}\" (#{resource.class})."
        end
        resource = resource.to_sym

        validate_verb! verb
        verb = verb.to_sym

        validate_action! action
        action = action.to_sym

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
          "#{prefix_namespace}#{resource_plural}"
        elsif action == :new
          "new_#{prefix_namespace}#{resource_singular}"
        elsif action == :edit
          "edit_#{prefix_namespace}#{resource_singular}"
        else
          # action == :show, :update, :destroy
          "#{prefix_namespace}#{resource_singular}"
        end
      end

      def uri_pattern
        @uri_pattern ||= if %i[index create].include?(action)
          "/#{path_namespace}#{resource_plural}"
        elsif action == :new
          "/#{path_namespace}#{resource_plural}/new"
        elsif action == :edit
          "/#{path_namespace}#{resource_plural}/:id/edit"
        else
          # action == :show, :update, :destroy
          "/#{path_namespace}#{resource_plural}/:id"
        end
      end
      alias path uri_pattern

      def controller_action
        @controller_action ||= "#{path_namespace}#{resource_plural}##{action}"
      end
    end
  end
end
