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
          "/#{namespace}#{resource_plural}"
        elsif action == :new
          "/#{namespace}#{resource_plural}/new"
        elsif action == :edit
          "/#{namespace}#{resource_plural}/:id/edit"
        else
          # action == :show, :update, :destroy
          "/#{namespace}#{resource_plural}/:id"
        end
      end
      alias path uri_pattern

      def controller_action
        @controller_action ||= "#{namespace}#{resource_plural}##{action}"
      end

      def namespace
        return if options[:namespace].blank?

        @namespace ||= "#{options[:namespace].join('/')}/"
      end

      def prefix_namespace
        return if options[:namespace].blank?

        @prefix_namespace ||= namespace.gsub('/', '_')
      end
    end
  end
end
