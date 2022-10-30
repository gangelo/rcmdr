# frozen_string_literal: true

require 'uri'
require_relative '../validators/action_validator'
require_relative '../validators/option_validator'
require_relative '../validators/verb_validator'
require_relative 'actions'
require_relative 'resource_route_info'
require_relative 'verbs'

module Rcmdr
  module Routing
    class Resources
      include Rcmdr::Validators::ActionValidator
      include Rcmdr::Validators::OptionValidator
      include Rcmdr::Validators::VerbValidator
      include Actions
      include Verbs

      attr_reader :resource, :action, :verb, :mod

      delegate :path, :resource_plural, :resource_singular, to: :resource_route_info

      class << self
        def verbs_for(action:)
          Rcmdr::Validators::ActionValidator.validate_action! action

          if action == :create
            [:post]
          elsif action == :destroy
            [:delete]
          elsif action == :update
            %i[put patch]
          elsif %i[edit index new show].include?(action)
            [:get]
          end
        end
      end

      def initialize(resource, **options)
        raise "Resource \"#{resource}\" (#{resource.class}) is not present?" unless resource.present?

        validate_options!(options: options.keys, allowed_options: %i[action mod verb])
        validate_required_options!(options: options.keys, required_options: %i[action verb])

        action = options[:action]
        verb = options[:verb]
        mod = options[:mod]

        validate_verb! verb
        validate_action! action

        @resource = resource
        @action = action
        @verb = verb
        @mod = mod

        @resource_route_info = ResourceRouteInfo.new(resource, verb:, action:, **options)
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

      def controller
        @controller ||= "#{module_formatted}#{resource_plural.capitalize}Controller"
      end

      def helper_path
        "#{resource_route_info.prefix}_path"
      end

      def helper_url
        "#{resource_route_info.prefix}_url"
      end

      def url_for(host:, scheme: 'rcmdr', port: nil)
        port = ":#{port.to_s.delete_prefix(':')}" unless port.blank?
        URI.join("#{scheme}://#{host}#{port}/", path).to_s
      end

      private

      attr_accessor :resource_route_info

      def module_formatted
        @module_formatted ||= "#{mod.to_s.capitalize}::" if mod.present?
      end
    end
  end
end
