# frozen_string_literal: true

require 'uri'
require_relative '../validators/controller_validator'
require_relative 'actions'
require_relative 'resource_route_info'
require_relative 'namespaces'
require_relative 'verbs'

module Rcmdr
  module Routing
    class Resources
      include Rcmdr::Validators::ControllerValidator
      include Actions
      include Namespaces
      include Verbs

      attr_reader :action, :resource, :verb

      delegate :path, :resource_plural, :resource_singular, to: :resource_route_info

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
            raise "Invalid action: \"#{action}\""
          end
        end
      end

      def initialize(resource, **options)
        raise "Resource \"#{resource}\" (#{resource.class}) is not present?" unless resource.present?

        @options = options.dup
        @action = options[:action]
        @verb = options[:verb]
        @to = options[:to]
        @resource = resource
        @resource_route_info = ResourceRouteInfo.new(resource, verb:, action:, **options)

        validate_controller! "#{path_namespace}#{resource_plural}"
      end

      def print
        "#{verb} #{path} -> #{controller}##{action}"
      end

      def to_h
        {
          resource:,
          action:,
          controller:,
          path:,
          helper_path:,
          helper_url:
        }
      end

      def controller
        @controller ||= "#{controller_namespace}#{resource_plural.capitalize}Controller"
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

      attr_accessor :options, :resource_route_info, :to
    end
  end
end
