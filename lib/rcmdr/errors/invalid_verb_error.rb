# frozen_string_literal: true

module Rcmdr
  module Errors
    # Indicates that an invalid verb was encountered.
    class InvalidVerbError < StandardError
      attr_reader :verb

      def initialize(verb:)
        @verb = verb

        super
      end

      def to_s
        "\"#{verb}\" (#{verb.class})"
      end
    end
  end
end
