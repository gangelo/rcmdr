# frozen_string_literal: true

require_relative '../validators/action_validator'
require_relative 'resources'

module Rcmdr
  module Routing
    class Resource < Resources
      extend Rcmdr::Validators::ActionValidator

      # class << self
      #   def verbs_for(action:)
      #     if action == :create
      #       [:post]
      #     elsif action == :destroy
      #       [:delete]
      #     elsif action == :update
      #       %i[put patch]
      #     elsif %i[edit new show].include?(action)
      #       [:get]
      #     else
      #       validate_action! action
      #     end
      #   end
      # end

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
