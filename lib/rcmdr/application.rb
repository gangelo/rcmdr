# frozen_string_literal: true

require_relative 'routes'

module Rcmdr
  # This class represents an rcmdr application.
  class Application
    attr_reader :routes

    def initialize
      self.routes = Routes.new
    end

    private

    attr_writer :routes
  end
end
