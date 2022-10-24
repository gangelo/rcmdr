# frozen_string_literal: true

module Rcmdr
  module Errors
    # Indicates that a recognized option was expected, but the option
    # was not recognized.
    class UnrecognizedOptionError < StandardError
      attr_reader :allowed_options, :unrecognized_options

      def initialize(allowed_options:, unrecognized_options:)
        @allowed_options = allowed_options
        @unrecognized_options = unrecognized_options

        super
      end

      def to_s
        "One or more of the following option(s) were expected \"#{allowed_options}\", " \
          "but \"#{unrecognized_options}\" were unrecognized"
      end
    end
  end
end
