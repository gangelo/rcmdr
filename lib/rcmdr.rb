# frozen_string_literal: true

# For #compact_blank
# For #to_sentence
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/delegation'
# For #singularize and #pluralize
require 'active_support/core_ext/string/inflections'

require 'immutable_struct_ex'

# 3rd-party
require_relative 'rcmdr/3rd-party/URI/rcmdr'

# Errors
require_relative 'rcmdr/errors/no_block_error'
require_relative 'rcmdr/errors/no_class_name_error'

# Routing
require_relative 'rcmdr/routing/actions'
require_relative 'rcmdr/routing/namespaces'
require_relative 'rcmdr/routing/options'
require_relative 'rcmdr/routing/resource'
require_relative 'rcmdr/routing/resource_route_info'
require_relative 'rcmdr/routing/resources'
require_relative 'rcmdr/routing/resource_mapper'
require_relative 'rcmdr/routing/root'
require_relative 'rcmdr/routing/route'
require_relative 'rcmdr/routing/route_info'
require_relative 'rcmdr/routing/route_mapper'
require_relative 'rcmdr/routing/path_parser'
require_relative 'rcmdr/routing/routes'
require_relative 'rcmdr/routing/verbs'

# Validators
require_relative 'rcmdr/validators/action_validator'
require_relative 'rcmdr/validators/controller_validator'
require_relative 'rcmdr/validators/option_validator'
require_relative 'rcmdr/validators/options_type_validator'
require_relative 'rcmdr/validators/root_route_validator'
require_relative 'rcmdr/validators/verb_validator'

require_relative 'rcmdr/application'
require_relative 'rcmdr/cli'
require_relative 'rcmdr/version'
