# frozen_string_literal: true

require_relative 'namespaces'
require_relative 'resources'

module Rcmdr
  module Routing
    class Resource < Resources
      include Namespaces

      def path
        @path ||= if %i[new edit].include?(action)
          "/#{path_namespace}#{resource}/#{action}"
        else
          "/#{path_namespace}#{resource}"
        end
      end
    end
  end
end
