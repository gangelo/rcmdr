# frozen_string_literal: true

require 'uri'
require_relative 'actions'
require_relative 'resource'
require_relative 'resources'
require_relative 'verbs'
require_relative '../errors/invalid_action_error'
require_relative '../errors/invalid_verb_error'
require_relative '..//errors/option_type_error'
require_relative '../errors/required_options_error'
require_relative '../errors/unrecognized_option_error'

module Rcmdr
  module Routing
    class ResourceMapper
      include Actions
      include Verbs

      class << self
        def map_resource(resource, **options)
          # The :index action is not used when using resource (singular)
          # in rails routes.
          options[:only] = options[:only] || (Actions::ACTIONS - [:index])
          map(resource, resource_class: Resource, **options)
        end

        def map_resources(resource, **options)
          options[:only] = options[:only] || Actions::ACTIONS
          map(resource, resource_class: Resources, **options)
        end

        private

        def map(resource, resource_class:, **options)
          only = options[:only]
          mod = options[:module]

          resource_class.validate_options!(allowed_options: %i[only module], options: options.keys)

          raise Rcmdr::Errors::OptionTypeError.new(option: only, expected_type: Array.class) unless only.is_a? Array

          resources = []

          only.each do |action|
            resource_class.verbs_for(action:).each do |verb|
              resources << resource_class.new(resource, action:, verb:, mod:)
            end
          end

          resources
        end
      end
    end
  end
end
