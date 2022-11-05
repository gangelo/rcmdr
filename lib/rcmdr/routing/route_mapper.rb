# frozen_string_literal: true

require_relative '../validators/option_validator'
require_relative '../validators/options_type_validator'
require_relative 'actions'
require_relative 'resource'
require_relative 'resources'
require_relative 'verbs'

module Rcmdr
  module Routing
    module RouteMapper
      module_function

      def map_root(path, **options)
        options[:to] = path if path
        Route.new('/', **options.merge!({ verb: :root }))
      end

      def map_route(path, verb:, **options)
        Route.new(path, **options.merge!({ verb: }))
      end
    end
  end
end
