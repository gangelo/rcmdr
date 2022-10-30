# frozen_string_literal: true

require_relative '../routing/verbs'

module Rcmdr
  module Validators
    module VerbValidator
      include Rcmdr::Routing::Verbs

      def verb_valid?(verb)
        VERBS.include? verb
      end

      def validate_verb!(verb)
        return if verb_valid? verb

        raise "Invalid verb encountered: \"#{verb}\" (#{verb.class})"
      end
    end
  end
end
