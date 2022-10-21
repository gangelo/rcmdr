# frozen_string_literal: true

require_relative '../errors/invalid_action_error'

module Rcmdr
  module Routing
    module Actions
      ACTIONS = %i[create destroy edit index new show update].freeze

      module_function

      def action_valid?(action)
        ACTIONS.include? action
      end

      def validate_action!(action)
        raise Errors::InvalidActionError.new(action: action) unless action_valid? action
      end
    end
  end
end
