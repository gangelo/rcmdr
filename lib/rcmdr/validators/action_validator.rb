# frozen_string_literal: true

require 'active_support/core_ext/array/conversions'
require_relative '../routing/actions'

module Rcmdr
  module Validators
    module ActionValidator
      class << self
        def included(_base)
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

        expected_actions = ACTIONS.to_sentence(
          two_words_connector: ' or ',
          last_word_connector: ' or ',
        )
        raise "Invalid verb. Expected \"#{expected_actions}\", " \
              "but received \"#{action}\" (#{action.class})."
      end
    end
  end
end
