# frozen_string_literal: true

require 'active_support/core_ext/array/conversions'

module Rcmdr
  module Validators
    module OptionsTypeValidator
      def options_type_valid?(option, allowed_types:)
        allowed_types = [allowed_types] unless allowed_types.is_a?(Array)
        allowed_types.any? { |allowed_type| option.is_a? allowed_type }
      end

      def validate_options_type!(option:, allowed_types:)
        allowed_types = [allowed_types] unless allowed_types.is_a?(Array)

        return if options_type_valid?(option, allowed_types:)

        expected_option_types = allowed_types.to_sentence(
          two_words_connector: ' or ',
          last_word_connector: ' or ',
        )
        raise "Invalid option type. Expected \"#{expected_option_types}\", " \
              "but received \"#{option}\" (#{option.class})."
      end
    end
  end
end
