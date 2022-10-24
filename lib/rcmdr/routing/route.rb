# frozen_string_literal: true

require_relative 'verbs'
require_relative '../errors/invalid_verb_error'

module Rcmdr
  module Routing
    class Route
      include Verbs

      attr_reader :route, :as, :verb, :action

      def initialize(route, as:, verb:)
        raise Errors::InvalidVerbError.new(verb:) unless VERBS.include? verb

        @route = route
        @as = as
        @verb = verb
      end

      def info
        Struct.new(
          :path,
          :helper_path,
          :helper_url,
          :controller_action
        ).new(path, helper_path,
          helper_url, controller_action)
      end

      def paths
        [route, helper_path, helper_url]
      end

      def path
        route
      end

      def helper_path
        route_helper_for(route:, as:, type: :path)
      end

      def helper_url
        route_helper_for(route:, as:, type: :url)
      end

      def controller_action
        raise Errors::InvalidActionError.new(action:) unless ACTIONS.include? action

        "#{resource}##{action}"
      end

      private

      # For example:
      # get '/cars/engines', to: 'car_engines#index', as: car_engines_list
      # => car_engines_list_path
      #
      # get '/cars/engines', to: 'car_engines#index'
      # => cars_engines_path
      def route_helper_for(route:, as:, type: :path)
        return "#{as}_#{type}" if as.present?

        path_tokens = route.split('/')
        return if path_tokens.any? { |token| token =~ /:.*/ }

        helper_path = path_tokens.filter_map do |path_token|
          next if path_token.blank?

          path_token = CGI.escape(path_token)
        end.compact.join('_')
        "#{helper_path}_#{type}" if helper_path.present?
      end
    end
  end
end
