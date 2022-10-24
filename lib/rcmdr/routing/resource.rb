# frozen_string_literal: true

require_relative 'resources'

module Rcmdr
  module Routing
    class Resource < Resources
      class << self
        def verbs_for(action:)
          if action == :create
            [:post]
          elsif action == :destroy
            [:delete]
          elsif action == :update
            %i[put patch]
          elsif %i[edit new show].include?(action)
            [:get]
          else
            raise Errors::InvalidActionError.new(action:)
          end
        end
      end

      def path
        @path ||= if %i[new edit].include?(action)
          "/#{resource}/#{action}"
        else
          "/#{resource}"
        end
      end
    end
  end
end
