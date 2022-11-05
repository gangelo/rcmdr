# frozen_string_literal: true

module Rcmdr
  module Routing
    module Root
      def root?
        verb.to_sym == :root
      end
    end
  end
end
