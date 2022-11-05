# frozen_string_literal: true

require_relative '../validators/option_validator'
require_relative '../validators/verb_validator'
require_relative 'path_parser'
require_relative 'root'
require_relative 'verbs'

module Rcmdr
  module Routing
    class Route
      include Rcmdr::Validators::OptionValidator
      include Rcmdr::Validators::VerbValidator
      include PathParser
      include Root
      include Verbs

      attr_reader :action, :as, :controller, :namespaces, :path, :to, :verb

      def initialize(path, **options)
        validate_options!(options: options.keys)

        # Check for required options
        missing_options = %i[verb] - options.keys
        validate_required_options!(options: options.keys, required_options: [:verb])

        verb = options[:verb].to_sym
        validate_verb! verb unless verb == :root

        @controller, @namespaces, @action = path_parse! path, **options
        @controller = "#{@controller.to_s.camelize}Controller"
        @namespaces = @namespaces.map { |namespace| namespace.to_s.camelize }
        @path = path
        @verb = verb
        @to = options[:to]
        @as = options[:as]
      end

      def print
        "#{verb} #{path} -> #{controller_class}##{action}"
      end

      def to_h
        {
          path:,
          verb:,
          namespaces:,
          controller:,
          controller_class:,
          action:,
          helper_path:,
          helper_url:
        }
      end

      def helper_path
        @helper_path ||= helper type: :path
      end

      def helper_url
        @helper_url ||= helper type: :url
      end

      def url_for(host:, scheme: 'rcmdr', port: nil)
        port = ":#{port.to_s.delete_prefix(':')}" unless port.blank?
        URI.join("#{scheme}://#{host}#{port}/", path).to_s
      end

      def controller_class
        all_namespaces = "#{namespaces.join('::')}::" if namespaces.present?
        @controller_class ||= "#{all_namespaces}#{controller}"
      end

      private

      def helper(type:)
        path = if as.present?
          as
        elsif root?
          :root
        else
          self.path.to_s.split('/').compact_blank.join('_')
        end

        "#{path}_#{type}"
      end

      # For example:
      # get '/cars/engines', to: 'car_engines#index', as: car_engines_list
      # => car_engines_list_path
      #
      # get '/cars/engines', to: 'car_engines#index'
      # => cars_engines_path
      #
      # Not implemented yet!
      #
      # def route_helper_for(path:, as:, type: :path)
      #   return "#{as}_#{type}" if as.present?

      #   path_tokens = path.split('/')
      #   return if path_tokens.any? { |token| token =~ /:.*/ }

      #   helper_path = path_tokens.filter_map do |path_token|
      #     next if path_token.blank?

      #     path_token = CGI.escape(path_token)
      #   end.compact.join('_')
      #   "#{helper_path}_#{type}" if helper_path.present?
      # end
    end
  end
end
