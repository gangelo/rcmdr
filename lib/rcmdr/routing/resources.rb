# frozen_string_literal: true

require 'uri'
require_relative 'actions'
require_relative 'verbs'
require_relative '../errors/invalid_action_error'
require_relative '../errors/invalid_resource_error'
require_relative '../errors/invalid_verb_error'

module Rcmdr
  module Routing
    class Resources
      include Actions
      include Verbs

      attr_reader :resource, :action, :verb, :mod

      class << self
        def verbs_for(action:)
          if action == :create
            [:post]
          elsif action == :destroy
            [:delete]
          elsif action == :update
            %i[put patch]
          elsif %i[edit index new show].include?(action)
            [:get]
          else
            raise Errors::InvalidActionError.new(action:)
          end
        end

        def resource_valid?(resource)
          resource.present?
        end

        def validate_resource!(resource)
          raise Errors::InvalidResourceError.new(resource:) unless resource_valid?(resource)
        end

        def validate_options!(allowed_options:, options:)
          unrecognized_options = options.filter_map do |option|
            next if allowed_options.include?(option)

            option
          end
          if unrecognized_options.present?
            raise Rcmdr::Errors::UnrecognizedOptionError.new(allowed_options:, unrecognized_options:)
          end
        end
      end

      def initialize(resource, **options)
        self.class.validate_resource! resource

        self.class.validate_options!(allowed_options: %i[action verb mod], options: options.keys)

        # Check for required options
        missing_options = %i[action verb] - options.keys
        raise Rcmdr::Errors::RequiredOptionsError.new(options: missing_options) if missing_options.present?

        action = options[:action]
        verb = options[:verb]
        mod = options[:mod]

        Rcmdr::Routing::Verbs.validate_verb! verb
        Rcmdr::Routing::Actions.validate_action! action

        @resource = resource
        @action = action
        @verb = verb
        @mod = mod
      end

      def print
        "#{verb} #{path} -> #{controller}##{action}"
      end

      def to_h
        {
          resource:,
          action:,
          controller:,
          mod:,
          path:,
          helper_path:,
          helper_url:
        }
      end

      def path
        @path ||= if %i[create index].include?(action)
          "/#{resource}"
        elsif action == :edit
          "/#{resource}/:id/edit"
        elsif action == :new
          "/#{resource}/new"
        elsif %i[destroy show update].include?(action)
          "/#{resource}/:id"
        end
      end

      def controller
        @controller ||= "#{module_formatted}#{resource.to_s.pluralize.capitalize}Controller"
      end

      def helper_path
        @helper_path ||= helper type: :path
      end

      def helper_url
        @helper_url ||= helper type: :url
      end

      def url_for(host:, path:, scheme: 'rcmdr', port: nil)
        port = ":#{port.to_s.delete_prefix(':')}" unless port.blank?
        URI.join("#{scheme}://#{host}#{port}/", path).to_s
      end

      private

      def helper(type:)
        resource = self.resource.to_s

        if (verb == :get && action == :index) ||
           (verb == :post && action == :create)
          return "#{resource}_#{type}"
        end

        if verb == :get
          if %i[new edit].include?(action)
            return "#{action}_#{resource.singularize}_#{type}"
          else
            return "#{resource.singularize}_#{type}"
          end
        end

        if (%i[patch put].include?(verb) && action == :update) ||
           (verb == :delete && action == :destroy)
          "#{resource.singularize}_#{type}"
        end
      end

      def module_formatted
        @module_formatted ||= "#{mod.to_s.capitalize}::" if mod.present?
      end
    end
  end
end
