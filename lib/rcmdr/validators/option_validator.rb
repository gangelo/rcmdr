# frozen_string_literal: true

require 'active_support/core_ext/array/conversions'
require_relative '../routing/options'

module Rcmdr
  module Validators
    module OptionValidator
      include Rcmdr::Routing::Options

      def option_valid?(option, allowed_options: nil)
        allowed_options = [allowed_options] unless allowed_options.is_a?(Array)
        (allowed_options || OPTIONS).include? option
      end

      # Validates options: against allowed_options:.
      # If allowed_options: is nil?, options: are validated
      # against OPTIONS. If any of the options: are unrecognized,
      # an error is raised.
      def validate_options!(options:, allowed_options: OPTIONS)
        allowed_options = [allowed_options] unless allowed_options.is_a?(Array)

        unrecognized_options = options.filter_map do |option|
          next if option_valid?(option, allowed_options:)

          option
        end

        if unrecognized_options.present?
          expected_allowed_options = allowed_options.to_sentence(
            two_words_connector: ' or ',
            last_word_connector: ' or '
          )
          unrecognized_options = unrecognized_options.to_sentence
          raise "Invalid optional options. Expected \"#{expected_allowed_options}\", " \
                "but received \"#{unrecognized_options}\"."
        end
      end

      # Validates options: against required_options:.
      # If required_options: is nil?, options: are validated
      # against OPTIONS. If any of the options: are missing,
      # an error is raised.
      def validate_required_options!(options:, required_options: OPTIONS)
        required_options = [required_options] unless required_options.is_a?(Array)

        missing_required_options = required_options - options

        if missing_required_options.present?
          expected_required_options = required_options.to_sentence(
            two_words_connector: ' or ',
            last_word_connector: ' or '
          )
          missing_required_options = missing_required_options.to_sentence
          raise "Missing required options. Expected \"#{expected_required_options}\", " \
                "but \"#{missing_required_options}\" are missing."
        end
      end
    end
  end
end
