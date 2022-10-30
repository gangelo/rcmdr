# frozen_string_literal: true

require 'active_support/core_ext/array/conversions'

module Rcmdr
  module Validators
    module ControllerValidator
      CONTROLLER_REGEX = %r{\A[a-z_0-9][a-z_0-9/]*\z}

      module_function

      def valid_controller?(controller)
        CONTROLLER_REGEX.match? controller
      end

      def validate_controller!(controller)
        return if valid_controller? controller

        raise "Unable to determine controller from: \"#{controller}\". " \
              "\"#{controller}\" is not a supported controller name."
      end
    end
  end
end
