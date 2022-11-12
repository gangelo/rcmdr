# frozen_string_literal: true

require_relative 'namespaces'
require_relative 'path_parser'
require_relative 'root'
require_relative 'route_info'
require_relative 'verbs'

module Rcmdr
  module Routing
    class Route
      include Namespaces
      include PathParser
      include Root
      include Verbs

      attr_reader :action, :controller, :path, :verb

      def initialize(path, **options)
        @options = options.dup

        @path = path

        @as = @options[:as]
        @to = @options[:to]
        @verb = @options[:verb]
        @route_info = RouteInfo.new(path, verb:, **@options)
        # TODO: Move path_parse and below attrs to RouteInfo?
        controller, namespaces, @action = path_parse! path, **@options
        namespaces = namespaces.map do |namespace|
          "#{namespace.to_s.camelize}::"
        end
        @controller = "#{namespaces.join}#{controller.to_s.camelize}Controller"
      end

      def print
        "#{verb} #{path} -> #{controller}##{action}"
      end

      def to_h
        {
          action:,
          controller:,
          helper_path:,
          helper_url:,
          path:,
          verb:
        }
      end

      def helper_path
        "#{route_info.prefix}_path"
      end

      def helper_url
        "#{route_info.prefix}_url"
      end

      def url_for(host:, scheme: 'rcmdr', port: nil)
        port = ":#{port.to_s.delete_prefix(':')}" unless port.blank?
        URI.join("#{scheme}://#{host}#{port}/", path).to_s
      end

      private

      attr_reader :as, :options, :namespaces, :route_info, :to
    end
  end
end
