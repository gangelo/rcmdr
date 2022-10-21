# frozen_string_literal: true

require_relative 'actions'
require_relative 'resource_paths'
require_relative 'route_verbs'
require_relative 'verbs'

module Rcmdr
  module Routing
    # This class takes care of routing: mapping/storing routes
    # and creating/providing path and url helper methods.
    class Routes
      include Actions
      include ResourcePaths
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
          route = resource_path_for resource, action: action
          to = resource_controller_action_for resource, action: action
          resource_path = resource_path(resource, action: action)
          verbs = verbs_for(action: action)
          verbs.each { |verb| send(verb, route, to: to) }
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
      end

      def resource_path(resource, action:)
        resource = resource.to_s.singularize

        case
        when action == :create || action == :index
          "#{resource}_path"
        when :new
          "new_#{resource.singularize}_path"
        when :edit
          "edit_#{resource.singularize}_path"
        when :index
          "/#{resource}"
        when %i[destroy show update].include?(action)
          "/#{resource}/:id"
        else
          raise Rcmdr::Errors::InvalidActionError.new(action: action)
        end
      end

      def resource_controller_action_for(resource, action:)
        raise Errors::InvalidActionError.new(action: action) unless ACTIONS.include? action

        "#{resource}##{action}"
      end
    end
  end
end
