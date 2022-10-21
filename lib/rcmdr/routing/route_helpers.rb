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

      def helper_path_for(verb:, resource_or_as:, action:)
        helper_for verb: verb, resource_or_as: resource_or_as, action: action
      end

      def helper_url_for(verb:, resource_or_as:, action:)
        helper_for(verb: verb, resource_or_as: resource_or_as, action: action, suffix: '_url')
      end

      def helper_for(verb:, resource_or_as:, action:, suffix: '_path')
        Rcmdr::Routing::Verbs.validate_verb! verb
        Rcmdr::Routing::Actions.validate_action! action

        resource_or_as = resource_or_as.to_s

        if %i[get post].include?(verb) && %i[index create].include?(action)
          "#{resource_or_as}#{suffix}"
        elsif verb == :get
          case action
          when :new
            "new_#{resource_or_as.singularize}#{suffix}"
          when :edit
            "edit_#{resource_or_as.singularize}#{suffix}"
          when :show
            "show_#{resource_or_as.singularize}#{suffix}"
          end
        elsif (%i[patch put].include?(verb) && action == :update) ||
              (verb == :delete && action == :destroy)
          "#{resource_or_as.singularize}#{suffix}"
        end
      end

      def url_for(host:, path:, scheme: 'rcmdr', port: nil)
        port = ":#{port.to_s.delete_prefix(':')}" unless port.blank?
        URI.join("#{scheme}://#{host}#{port}/", path).to_s
      end
    end
  end
end
