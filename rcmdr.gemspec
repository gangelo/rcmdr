# frozen_string_literal: true

require_relative 'lib/rcmdr/version'

Gem::Specification.new do |spec|
  spec.name = 'rcmdr'
  spec.version = Rcmdr::VERSION
  spec.authors      = ['Gene M. Angelo, Jr.']
  spec.email        = ['public.gma@gmail.com']

  spec.summary      = 'rcmdr, the RESTful command manager/interpreter gem.'
  spec.description  = <<-DESC
    rcmdr a Ruby gem that uses a RESTful approach to managing and interpreting
    commands and their requests. A "command" being defined as any action that may
    be carried out in a manner consistent with the following REST verbs GET, POST,
    PUT, PATCH, DELETE and OPTIONS.
  DESC
  spec.homepage = 'https://github.com/gangelo/rcmdr'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.1'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/gangelo/rcmdr/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 7.0', '>= 7.0.4'
  spec.add_dependency 'deco_lite', '~> 1.3'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
