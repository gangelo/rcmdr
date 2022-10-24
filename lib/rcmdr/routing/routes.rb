# frozen_string_literal: true

require_relative 'actions'
require_relative 'resource'
require_relative 'route'
require_relative 'verbs'

module Rcmdr
  module Routing
    # This class takes care of routing: mapping/storing routes
    # and creating/providing path and url helper methods.
    class Routes
      include Actions
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

        # TODO: Create a clean-room so that the block cannot execute
        # arbitrary code.
        instance_eval(&block)
        self
      end

      private

      attr_writer :routes, :paths

      def resources(resource, only: ACTIONS)
        raise "#{resource} is not a Symbol" unless resource.is_a? Symbol

        only.each do |action|
          verbs_for(action:).each do |verb|
            resource_info = Resources.new(resource, action:, verb:).info
            add_route(resource_info.path, to: resource_info.controller_action, verb:)
            helper_path = resource_info.helper_path
            next if helper_path.nil? || paths[helper_path].present?

            paths[helper_path] = resource_info.path
          end
        end
      end
      alias resource resources

      def add_resource_path(route:, **options)
      end

      def root(route, **options)
        get route, **options.merge({ to: :root })
      end

      def delete(route, **options)
        add_route(route, **options.merge({ verb: :delete }))
        add_route_path(route:, as: options[:as])
      end

      def get(route, **options)
        add_route(route, **options.merge({ verb: :get }))
        add_route_path(route:, as: options[:as])
      end

      def post(route, **options)
        add_route(route, **options.merge({ verb: :post }))
        add_route_path(route:, as: options[:as])
      end

      def patch(route, **options)
        add_route(route, **options.merge({ verb: :patch }))
        add_route_path(route:, as: options[:as])
      end

      def put(route, **options)
        add_route(route, **options.merge({ verb: :put }))
        add_route_path(route:, as: options[:as])
      end

      def add_route(route, **options)
        missing_options = %i[verb] - options.keys
        raise Errors::RequiredOptionsError.new(options: missing_options) unless missing_options.blank?

        verb = options[:verb]

        routes[verb][route] = {}
        routes[verb][route][:to] = options[:to]
        routes[verb][route]
      end

      def add_route_path(route:, as:)
        helper_path = Route.new(route, as:).helper_path
        return if helper_path.nil? || paths[helper_path].present?

        paths[helper_path] = route
      end
    end
  end
end
