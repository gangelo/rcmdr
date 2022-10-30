# frozen_string_literal: true

require_relative '../routing/actions'

module Rcmdr
  module Validators
    module ActionValidator
      class << self
        def included(base)
          include Rcmdr::Routing::Actions
        end

        def extended(base)
          base.extend Rcmdr::Routing::Actions
        end
      end

      module_function

      def action_valid?(action)
        ACTIONS.include? action
      end

      def validate_action!(action)
        return if action_valid? action

        raise "Invalid action encountered: \"#{action}\" (#{action.class})."
      end
    end
  end
end
