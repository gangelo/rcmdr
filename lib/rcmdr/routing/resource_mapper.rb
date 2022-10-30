# frozen_string_literal: true

require_relative '../validators/option_validator'
require_relative '../validators/options_type_validator'
require_relative 'actions'
require_relative 'resource'
require_relative 'resources'
require_relative 'verbs'

module Rcmdr
  module Routing
    class ResourceMapper
      extend Rcmdr::Validators::OptionValidator
      extend Rcmdr::Validators::OptionsTypeValidator
      extend Actions
      extend Verbs

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

          validate_options!(options: options.keys, allowed_options: %i[only module])
          validate_options_type!(option: only, allowed_types: Array)

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
