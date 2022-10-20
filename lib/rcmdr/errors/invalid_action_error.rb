# frozen_string_literal: true

module Rcmdr
  module Errors
    # Indicates that an invalid action was encountered.
    class InvalidActionError < StandardError
      attr_reader :action

      def initialize(action:)
        @action = action

        super
      end

      def to_s
        "\"#{action}\" (#{action.class})"
      end
    end
  end
end
