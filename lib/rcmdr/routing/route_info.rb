# frozen_string_literal: true

require_relative '../validators/action_validator'
require_relative '../validators/option_validator'
require_relative '../validators/root_route_validator'
require_relative '../validators/verb_validator'
require_relative 'path_parser'
require_relative 'root'

module Rcmdr
  module Routing
    class RouteInfo
      include Rcmdr::Validators::ActionValidator
      include Rcmdr::Validators::OptionValidator
      include Rcmdr::Validators::RootRouteValidator
      include Rcmdr::Validators::VerbValidator
      include PathParser
      include Root

      attr_reader :path, :verb, :options, :to, :as

      alias uri_pattern path

      def initialize(path, verb:, **options)
        unless path.is_a?(String) && path.present?
          raise 'Path is invalid. Expected a non-blank? String, ' \
                "but recieved \"#{path}\" (#{path.class})."
        end
        @path = path

        @verb = verb.to_sym
        validate_verb! verb unless root?

        validate_options!(options: options.keys, allowed_options: %i[as to])

        @options = options
        @to = options[:to]
        @as = options[:as]

        validate_root_controller_action!(to || path) if root?
      end

      def prefix
        @prefix ||= if root?
          as || 'root'
        else
          as || path.split('/').compact_blank.join('_')
        end
      end

      def controller_action
        @controller_action ||= if root?
          root_controller_action
        else
          route_controller_action
        end
      end

      private

      def root_controller_action
        raise 'Route is not root' unless root?

        # If root, and both path and option :to are used, path wins out.
        path || to
      end

      def route_controller_action
        controller, namespaces, action = path_parse!(path, **options)

        [namespaces, "#{controller}##{action}"].flatten.join('/')
      end

      def namespaces
        'TODO: return namespaces'
      end
    end
  end
end
