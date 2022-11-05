# frozen_string_literal: true

require_relative '../validators/option_validator'
require_relative 'actions'
require_relative 'resource_mapper'
require_relative 'route'
require_relative 'route_mapper'
require_relative 'verbs'

module Rcmdr
  module Routing
    # This class takes care of routing: mapping/storing routes
    # and creating/providing path and url helper methods.
    class Routes
      include Rcmdr::Validators::OptionValidator
      include Actions
      include Verbs

      attr_reader :routes, :paths

      def initialize
        self.routes = VERBS.to_h { |verb| [verb, {}] }
        routes[:root] = {}
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
        ResourceMapper.map_resources(resource, only:).tap do |resources_maps|
          resources_maps.each do |resources_map|
            add_resource_route resources_map
            add_resource_path resources_map
          end
        end
      end

      def resource(resource, only: ACTIONS - [:index])
        ResourceMapper.map_resource(resource, only:).tap do |resource_maps|
          resource_maps.each do |resource_map|
            add_resource_route resource_map
            add_resource_path resource_map
          end
        end
      end

      def root(path, **options)
        route_map = RouteMapper.map_root path, **options
        add_resource_route route_map
        add_resource_path route_map
      end

      def delete(path, **options)
        route_map = RouteMapper.map_route path, verb: :delete, **options
        add_resource_route route_map
        add_resource_path route_map
      end

      def get(path, **options)
        route_map = RouteMapper.map_route path, verb: :get, **options
        add_resource_route route_map
        add_resource_path route_map
      end

      def post(path, **options)
        route_map = RouteMapper.map_route path, verb: :post, **options
        add_resource_route route_map
        add_resource_path route_map
      end

      def patch(path, **options)
        route_map = RouteMapper.map_route path, verb: :patch, **options
        add_resource_route route_map
        add_resource_path route_map
      end

      def put(path, **options)
        route_map = RouteMapper.map_route path, verb: :put, **options
        add_resource_route route_map
        add_resource_path route_map
      end

      # Add routes for resources and resource from their
      # respective mapper.
      def add_resource_route(mapper)
        verb = mapper.verb
        path = mapper.path

        routes[verb] ||= verb
        routes[verb][path] ||= {}
        routes[verb][path][:controller] = mapper.controller
        routes[verb][path][:action] = mapper.action
        routes[verb][path]
      end

      # Add paths and urls for resources and resource from their
      # respective mapper.
      def add_resource_path(mapper)
        path = mapper.path

        helper_path = mapper.helper_path
        paths[helper_path] ||= {}
        paths[helper_path] = path

        helper_url = mapper.helper_url
        paths[helper_url] ||= {}
        paths[helper_url] = mapper.url_for(host: 'app', scheme: 'rcmdr', port: nil)
      end
    end
  end
end
