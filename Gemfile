# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in maketable.gemspec
gemspec

gem 'bundler'
gem "coderay", "~> 1.1.3"
gem "debug", ">= 1.0.0"
gem "rake", "~> 13.1"
gem "rufo"
gem 'simpleoptparse'
gem 'ykutils'
gem 'ykxutils'

group :test, optional: true do
  gem "aruba"
  gem "clitest"
  gem "pre-commit"
  gem "rb-readline"
  gem "redcarpet"
  gem "rspec", "~> 3.0"
  gem "rspec_junit_formatter"
  gem "rubocop", "~> 1.59"
  gem "rubocop-rake"
  gem "rubocop-rspec"
end

group :development do
  gem "guard-yard"
  gem "yard"
  gem "yard-activesupport-concern"
end
# gem "erubi"
