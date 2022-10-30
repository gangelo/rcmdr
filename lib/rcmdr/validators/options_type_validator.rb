# frozen_string_literal: true

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

        raise "Invalid option type. Expected \"#{allowed_types.join(' or ')}\", " \
              "but received (#{option.class})"
      end
    end
  end
end
