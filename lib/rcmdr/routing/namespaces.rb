# frozen_string_literal: true

module Rcmdr
  module Routing
    module Namespaces
      def namespace?
        namespace.present?
      end

      def namespace
        @namespace ||= options[:namespace] || []
      end

      def controller_namespace
        return unless namespace?

        @controller_namespace ||= to_controller_namespace(namespace).join
      end

      def to_controller_namespace(namespaces)
        raise "Argument \"namespaces\" is not an Array (#{namespaces.class})" unless namespaces.is_a? Array

        namespaces.map do |namespace|
          "#{namespace.to_s.capitalize}::"
        end
      end

      def prefix_namespace
        return unless namespace?

        @prefix_namespace ||= path_namespace.tr('/', '_')
      end

      def path_namespace
        return unless namespace?

        @path_namespace ||= "#{namespace.join('/')}/"
      end
    end
  end
end
