# frozen_string_literal: true

require_relative 'actions'
require_relative 'verbs'
require_relative 'support/resource_paths'
require_relative 'support/route_verbs'

module Rcmdr
  # This class takes care of routing: mapping/storing routes
  # and creating/providing path and url helper methods.
  class Routes
    include Actions
    include Verbs
    include Support::ResourcePaths
    include Support::RouteVerbs

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

    # photos_path returns /photos
    # new_photo_path returns /photos/new
    # edit_photo_path(:id) returns /photos/:id/edit (for instance, edit_photo_path(10) returns /photos/10/edit)
    # photo_path(:id) returns /photos/:id (for instance, photo_path(10) returns /photos/10)

    def resources(resource, only: ACTIONS)
      raise "#{resource} is not a Symbol" unless resource.is_a? Symbol

      only.each do |action|
        route = resource_path_for resource, action: action
        to = resource_controller_action_for resource, action: action
        resource_path = resource_path(resource, action: action)
        verb = verb_for(action: action)
        puts "#{verb} #{resource_path}"
        send(verb, route, to: to)
      end
    end
    alias_method :resource, :resources

    def delete(route, **options)
      add_route(route, **options.merge({ verb: :delete }))
    end

    def get(route, **options)
      add_route(route, **options.merge({ verb: :get }))
    end

    def post(route, **options)
      add_route(route, **options.merge({ verb: :post }))
    end

    def put(route, **options)
      add_route(route, **options.merge({ verb: :put }))
    end
    alias patch put

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
      case action
      when :create || :index
        "#{resource}_path"
      when :new
        "new_#{resource.singularize}_path"
      when :edit
        "edit_#{resource.singularize}_path"

      when :destroy
        "/#{resource}/:id"
      when :index
        "/#{resource}"
      when :show
        "/#{resource}/:id"
      when :update
        "/#{resource}/:id"
      else
        raise Rcmdr::Errors::InvalidActionError.new(action: action)
      end
    end

    def route_path(as, verb:)
      return "#{as}_path" if as.present?
    end

    def resource_controller_action_for(resource, action:)
      raise Errors::InvalidActionError.new(action: action) unless ACTIONS.include? action

      "#{resource}##{action}"
    end
  end
end
