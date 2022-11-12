# frozen_string_literal: true

require 'active_support/core_ext/array/conversions'
require_relative 'controller_validator'

module Rcmdr
  module Validators
    module RootRouteValidator
      module_function

      def valid_root_controller_action?(root_controller_action)
        return false if root_controller_action.blank?
        # Cannot begin with forward-slash
        return false if root_controller_action.start_with?('/')

        controller_action_parts = root_controller_action.split('#')
        unless controller_action_parts.count == 2
          # We have to have a controller and an action
          return false
        end

        controller, _action = controller_action_parts
        ControllerValidator.valid_controller?(controller)
      end

      def validate_root_controller_action!(root_controller_action)
        return if valid_root_controller_action? root_controller_action

        raise 'Invalid root controller and action. ' \
              "Unable to determine root controller and action from \"#{root_controller_action}\". " \
              "\"#{root_controller_action}\" is not a supported root controller " \
              'and action format and/or combination.'
      end
    end
  end
end
