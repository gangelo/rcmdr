# frozen_string_literal: true

require 'uri'
require_relative 'actions'
require_relative 'verbs'

module Rcmdr
  module Routing
    # This module provides methods to generate route path
    # and url helpers.
    module ResourceHelpers
      module_function

      def resource_helper_path_for(resource:, verb:, action:)
        resource_helper_for resource:, verb:, action:
      end

      def resource_helper_url_for(resource:, verb:, action:)
        resource_helper_for resource:, verb:, action:, suffix: '_url'
      end

      def resource_helper_for(resource:, verb:, action:, suffix: '_path')
        Rcmdr::Routing::Verbs.validate_verb! verb
        Rcmdr::Routing::Actions.validate_action! action

        resource = resource.to_s

        if %i[get post].include?(verb) && %i[index create].include?(action)
          return "#{resource}#{suffix}"
        end

        if verb == :get
          if %i[new edit show].include?(action)
            return "#{action}_#{resource.singularize}#{suffix}"
          else
            return "#{resource}#{suffix}"
          end
        end

        if (%i[patch put].include?(verb) && action == :update) ||
              (verb == :delete && action == :destroy)
          "#{resource.singularize}#{suffix}"
        end
      end

      def url_for(host:, path:, scheme: 'rcmdr', port: nil)
        port = ":#{port.to_s.delete_prefix(':')}" unless port.blank?
        URI.join("#{scheme}://#{host}#{port}/", path).to_s
      end
    end
  end
end
