# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inflections'

# 3rd-party
require_relative 'rcmdr/3rd-party/URI/rcmdr'

# Errors
require_relative 'rcmdr/errors/invalid_action_error'
require_relative 'rcmdr/errors/invalid_resource_error'
require_relative 'rcmdr/errors/invalid_verb_error'
require_relative 'rcmdr/errors/no_block_error'
require_relative 'rcmdr/errors/no_class_name_error'
require_relative 'rcmdr/errors/option_type_error'
require_relative 'rcmdr/errors/required_options_error'
require_relative 'rcmdr/errors/unrecognized_option_error'

# Routing
require_relative 'rcmdr/routing/actions'
require_relative 'rcmdr/routing/resource'
require_relative 'rcmdr/routing/resources'
require_relative 'rcmdr/routing/resource_mapper'
require_relative 'rcmdr/routing/route'
require_relative 'rcmdr/routing/routes'
require_relative 'rcmdr/routing/verbs'

require_relative 'rcmdr/application'
require_relative 'rcmdr/cli'
require_relative 'rcmdr/version'
