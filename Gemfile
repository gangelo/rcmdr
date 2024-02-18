# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in rcmdr.gemspec
gemspec

group :development do
  gem 'pry-byebug', '~> 3.9'
  gem 'reek', '~> 6.1', '>= 6.1.1'
  gem 'rubocop', '~> 1.60', '>= 1.60.2'
  gem 'rubocop-performance', '~> 1.20', '>= 1.20.2'
  gem 'rubocop-rake', '~> 0.6.0'
  gem 'rubocop-rspec', '~> 2.26', '>= 2.26.1'
end

group :test do
  gem 'rspec', '~> 3.0'
  gem 'simplecov', '~> 0.21.2'
end

group :development, :test do
  gem 'rake', '~> 13.0'
end
