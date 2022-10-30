# frozen_string_literal: true

require_relative '../routing/options'

module Rcmdr
  module Validators
    module OptionValidator
      include Rcmdr::Routing::Options

      def option_valid?(option, allowed_options: nil)
        (allowed_options || OPTIONS).include? option
      end

      # Validates options: against allowed_options:.
      # If allowed_options: is nil?, options: are validated
      # against OPTIONS. If any of the options: are unrecognized,
      # an error is raised.
      def validate_options!(options:, allowed_options: OPTIONS)
        unrecognized_options = options.filter_map do |option|
          next if option_valid?(option, allowed_options:)

          option
        end

        if unrecognized_options.present?
          raise 'One or more of the following optional options were not expected ' \
                "\"#{unrecognized_options}\"."
        end
      end

      # Validates options: against required_options:.
      # If required_options: is nil?, options: are validated
      # against OPTIONS. If any of the options: are missing,
      # an error is raised.
      def validate_required_options!(options:, required_options: OPTIONS)
        missing_required_options = required_options - options

        if missing_required_options.present?
          raise "One or more of the following required options were expected \"#{required_options}\", " \
                "but \"#{missing_required_options}\" were missing."
        end
      end
    end
  end
end
