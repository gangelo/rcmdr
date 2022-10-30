# frozen_string_literal: true

# https://github.com/rails/rails/blob/95fa021465499c820f3b8758bb014b8549b2d13d/actionpack/lib/action_dispatch/routing/mapper.rb

require_relative '../validators/controller_validator'

module Rcmdr
  module Routing
    module PathParser
      PATH_WITH_SLUG = /.*:.*/

      def path_parse!(path, **options)
        raise "Unable to determine controller action from path \"#{path}\"." if path.blank?

        # TODO: Apply options[:namespace] which would be an array
        # of namespaces to apply to: path, options[:to] and affect
        # helper path and url generated (unless option[:as] specified)
        to = options[:to]
        if to.present?
          controller_segments, action = to.split('#').compact_blank
          if action.nil?
            raise "Unable to determine controller action from to: \"#{to}\". " \
                  'You must add an action (e.g. to:[<namespace>/...]<controller>#<action>) ' \
                  'to resolve this ambiguity.'
          end

          # Check namespace (if it present) and controller
          Rcmdr::Validators::ControllerValidator.validate_controller! controller_segments

          controller_segments = controller_segments.split('/').compact_blank
          controller = controller_segments.pop
          namespaces = controller_segments

          return [controller, namespaces, action]
        end

        if PATH_WITH_SLUG.match? path
          raise "Unable to determine controller action from path \"#{path}\". " \
                'If your path includes a slug (e.g. :id), you must supply ' \
                'to: "<controller>#<action>" to resolve this ambiguity.'
        end

        Rcmdr::Validators::ControllerValidator.validate_controller! path.sub(%r{^/}, '')

        path_segments = path.split('/').compact_blank
        if path_segments.count == 1
          raise "Unable to determine controller action from path \"#{path}\". " \
                'If your path includes only 1 segment (e.g. /segment), you must add additional ' \
                'path controller_segments or supply to: "<controller>#<action>" to resolve this ambiguity.'
        end

        controller = path_segments[0]
        namespaces = path_segments[1..-2]
        action = path_segments[-1]

        [controller, namespaces, action]
      end
    end
  end
end
