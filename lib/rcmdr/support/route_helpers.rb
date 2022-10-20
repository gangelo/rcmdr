# frozen_string_literal: true

require_relative '../actions'
require_relative '../verbs'

module Rcmdr
  module Support
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
        Rcmdr::Verbs.validate_verb! verb
        Rcmdr::Actions.validate_action! action

        resource_or_as = resource_or_as.to_s

        case
        when %i[get post].include?(verb) && %i[index create].include?(action)
          "#{resource_or_as}_path"
        when verb == :get
          case action
          when :new
            "new_#{resource_or_as.singularize}_path"
          when :edit
            "edit_#{resource_or_as.singularize}_path"
          when :show
            "show_#{resource_or_as.singularize}_path"
          end
        when %i[patch put].include?(verb) && action == :update
          "#{resource_or_as.singularize}_path"
        when verb == :delete && action == :destroy
          "#{resource_or_as.singularize}_path"
        else
          # TODO: raise
        end
      end

      # def helper_url_for(verb:, resource_or_as:, action:, protocol: 'rcmdr', uri:)
      #   helper = helper_for(verb: verb, resource_or_as: resource_or_as, action: action, suffix: '_url')
      #   "#{protocol}://#{uri}#{helper}"
      # end
    end
  end
end
