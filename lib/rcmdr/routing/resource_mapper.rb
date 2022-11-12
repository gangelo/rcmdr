# frozen_string_literal: true

require_relative 'actions'
require_relative 'resource'
require_relative 'resources'
require_relative 'verbs'

module Rcmdr
  module Routing
    class ResourceMapper
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
          raise "options[:only] is not an Array (#{options[:only].class})" unless options[:only].is_a?(Array)

          resources = []

          options[:only].each do |action|
            resource_class.verbs_for(action:).each do |verb|
              resources << resource_class.new(resource, verb:, action:, **options)
            end
          end

          resources
        end
      end
    end
  end
end
