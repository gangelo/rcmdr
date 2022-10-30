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

        expected_verbs = VERBS.to_sentence(
          two_words_connector: ' or ',
          last_word_connector: ' or ',
        )
        raise "Invalid verb. Expected \"#{expected_verbs}\", " \
              "but received \"#{verb}\" (#{verb.class})."
      end
    end
  end
end
