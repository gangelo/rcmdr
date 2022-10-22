# frozen_string_literal: true

require 'uri'
require_relative 'actions'
require_relative 'verbs'

module Rcmdr
  module Routing
    # This module provides methods to generate route path
    # and url helpers.
    module RouteHelpers
      module_function

      def route_helper_path_for(route:, as:)
        route_helper_for route:, as:
      end

      def route_helper_url_for(route:, as:)
        route_helper_for route:, as:, suffix: '_url'
      end

      # For example:
      # get '/cars/engines', to: 'car_engines#index', as: car_engines_list
      # => car_engines_list_path
      #
      # get '/cars/engines', to: 'car_engines#index'
      # => cars_engines_path
      def route_helper_for(route:, as:, suffix: '_path')
        return "#{as}#{suffix}" if as.present?

        path_tokens = route.split('/')
        return if path_tokens.any? { |token| token =~ /:.*/ }

        helper_path = path_tokens.filter_map do |path_token|
          next if path_token.blank?

          path_token = CGI.escape(path_token)
        end.compact.join('_')
        "#{helper_path}#{suffix}" if helper_path.present?
      end
    end
  end
end
