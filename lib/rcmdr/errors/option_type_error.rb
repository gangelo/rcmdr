# frozen_string_literal: true

module Rcmdr
  module Errors
    # Indicates that an option type was expected, but the option
    # type was the wrong type.
    class OptionTypeError < StandardError
      attr_reader :option, :expected_type

      def initialize(option:, expected_type:)
        @option = option
        @expected_type = expected_type

        super
      end

      def to_s
        "Option type \"#{expected_type.class}\" was expected, " \
          "but \"#{option.class}\" was received"
      end
    end
  end
end
