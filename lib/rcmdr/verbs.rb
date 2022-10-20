# frozen_string_literal: true

require_relative 'errors/invalid_verb_error'

module Rcmdr
  module Verbs
    VERBS = %i[get post put patch delete].freeze

    module_function

    def verb_valid?(verb)
      VERBS.include? verb
    end

    def validate_verb!(verb)
      raise Errors::InvalidVerbError.new(verb: verb) unless verb_valid? verb
    end
  end
end
