# frozen_string_literal: true

module Rcmdr
  module Errors
    # Indicates that an option was expected, but the option
    # was missing.
    class RequiredOptionsError < StandardError
      attr_reader :options

      def initialize(options:)
        @options = options

        super
      end

      def to_s
        "Required option(s) \"#{options}\" missing"
      end
    end
  end
end
