# frozen_string_literal: true

require_relative 'actions'
require_relative 'resource_paths'
require_relative 'resource_helpers'
require_relative 'route_helpers'
require_relative 'route_verbs'
require_relative 'verbs'

module Rcmdr
  module Routing
    # This class takes care of routing: mapping/storing routes
    # and creating/providing path and url helper methods.
    class Routes
      include Actions
      include ResourcePaths
      include ResourceHelpers
      include RouteHelpers
      include RouteVerbs
      include Verbs

      # Hash:
      # { <verb>: { route: "<route>", to: "<controller/action>" } }
      attr_reader :routes, :paths

      def initialize
        self.routes = VERBS.to_h { |verb| [verb, {}] }
        self.paths = {}
      end

      # https://www.krengeltech.com/2017/12/ruby-and-dsls-and-blocks/
      def draw(&block)
        raise Errors::NoBlockError unless block

        instance_eval(&block)
        self
      end

      private

      attr_writer :routes, :paths

      def resources(resource, only: ACTIONS)
        raise "#{resource} is not a Symbol" unless resource.is_a? Symbol

        only.each do |action|
          verbs_for(action:).each do |verb|
            resource_path = resource_path_for resource, action: action
            send(verb,
              resource_path,
              to: resource_controller_action_for(resource, action:))
            #paths[resource_helper_path_for(verb:, resource: resource, action:)] = resource_path
            #paths[route_helper_path_for(route:, verb:, as:)] = route
          end
        end
      end
      alias resource resources

      def delete(route, **options)
        add_route(route, **options.merge({ verb: :delete }))
      end

      def get(route, **options)
        add_route(route, **options.merge({ verb: :get }))
      end

      def post(route, **options)
        add_route(route, **options.merge({ verb: :post }))
      end

      def patch(route, **options)
        add_route(route, **options.merge({ verb: :patch }))
      end

      def put(route, **options)
        add_route(route, **options.merge({ verb: :put }))
      end

      def add_route(route, **options)
        missing_options = %i[verb to] - options.keys
        raise RequiredOptionsError.new(options: missing_options) unless missing_options.blank?

        verb = options[:verb]

        routes[verb][route] = {}
        routes[verb][route][:to] = options[:to]
        yield routes[verb][route] if block_given?
        routes[verb][route]

        add_path(route:, as: options[:as])
      end

      def add_path(route:, as:)
        path = route_helper_path_for(route:, as:)
        return if path.nil? || paths[path].present?

        paths[path] = route
      end

      def resource_controller_action_for(resource, action:)
        raise Errors::InvalidActionError.new(action:) unless ACTIONS.include? action

        "#{resource}##{action}"
      end
    end
  end
end
