# frozen_string_literal: true

require_relative '../validators/action_validator'
require_relative 'resources'

module Rcmdr
  module Routing
    class Resource < Resources
      extend Rcmdr::Validators::ActionValidator

      def path
        @path ||= if %i[new edit].include?(action)
          "/#{path_namespace}#{resource}/#{action}"
        else
          "/#{path_namespace}#{resource}"
        end
      end

      private

      def path_namespace
        return if options[:namespace].blank?

        @path_namespace ||= "#{options[:namespace].join('/')}/"
      end

      def prefix_namespace
        return if options[:namespace].blank?

        @prefix_namespace ||= path_namespace.gsub('/', '_')
      end
    end
  end
end
