# frozen_string_literal: true

module Rcmdr
  module Errors
    # Indicates that no &block was provided where a &block
    # was expected.
    class NoBlockError < StandardError
      def to_s
        # 'A &block was expected, but no block was given (block_given? == false)'
      end
    end
  end
end
