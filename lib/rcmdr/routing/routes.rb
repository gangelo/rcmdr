# frozen_string_literal: true

require_relative '../validators/option_validator'
require_relative 'actions'
require_relative 'resource_mapper'
require_relative 'route'
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
            add_resource_paths resources_map
          end
        end
      end

      def resource(resource, only: ACTIONS - [:index])
        ResourceMapper.map_resource(resource, only:).tap do |resource_maps|
          resource_maps.each do |resource_map|
            add_resource_route resource_map
            add_resource_paths resource_map
          end
        end
      end

      def root(path, **options)
        options[:to] = path if path
        add_route('/', **options.merge!({ verb: :root }))
        add_route_path(path: '/', **options)
      end

      def delete(path, **options)
        add_route(path, **options.merge!({ verb: :delete }))
        add_route_path(path:, **options)
      end

      def get(path, **options)
        add_route(path, **options.merge!({ verb: :get }))
        add_route_path(path:, **options)
      end

      def post(path, **options)
        add_route(path, **options.merge!({ verb: :post }))
        add_route_path(path:, **options)
      end

      def patch(path, **options)
        add_route(path, **options.merge!({ verb: :patch }))
        add_route_path(path:, **options)
      end

      def put(path, **options)
        add_route(path, **options.merge!({ verb: :put }))
        add_route_path(path:, **options)
      end

      def add_route(path, **options)
        validate_required_options!(options: options.keys, required_options: %i[verb to])

        verb = options[:verb]
        routes[verb][path] = {}
        routes[verb][path][:to] = options[:to]
        routes[verb][path]
      end

      def add_route_path(path:, **options)
        mapper = Route.new(path, **options)

        path = mapper.path

        helper_path = mapper.helper_path
        paths[helper_path] ||= {}
        paths[helper_path] = path

        helper_url = mapper.helper_url
        paths[helper_url] ||= {}
        paths[helper_url] = mapper.url_for(host: 'app', scheme: 'rcmdr', port: nil)
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
      def add_resource_paths(mapper)
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
