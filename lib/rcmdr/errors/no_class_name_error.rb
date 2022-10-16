# frozen_string_literal: true

module Rcmdr
  class NoClassNameError < StandardError
    def to_s
      'The class has no name (<class>.name.blank?)'
    end
  end
end
