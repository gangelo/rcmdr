# frozen_string_literal: true

module Rcmdr
  module Errors
    # Indicates that a valid resource was expected, but the resource
    # was invalid.
    class InvalidResourceError < StandardError
      attr_reader :resource

      def initialize(resource:)
        @resource = resource

        super
      end

      def to_s
        "Invalid resource \"#{resource.class.name}\""
      end
    end
  end
end
