# frozen_string_literal: true

require_relative '../validators/action_validator'
require_relative 'resources'

module Rcmdr
  module Routing
    class Resource < Resources
      extend Rcmdr::Validators::ActionValidator

      def path
        @path ||= if %i[new edit].include?(action)
          "/#{resource}/#{action}"
        else
          "/#{resource}"
        end
      end
    end
  end
end
