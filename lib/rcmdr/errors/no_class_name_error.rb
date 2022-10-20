# frozen_string_literal: true

module Rcmdr
  module Errors
    # Indicates that a dynamically created class (Class.new...)
    # is missing a class name.
    class NoClassNameError < StandardError
      def to_s
        '<class>#name is blank?'
      end
    end
  end
end
