# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem 'bump', require: false
gem 'minitest', '~> 5.11'
gem 'minitest-proveit'
gem 'prism'
gem 'rake'
gem 'rubocop', github: 'rubocop/rubocop'
gem 'rubocop-performance', '~> 1.22.0'
gem 'test-queue'
gem 'yard', '~> 0.9'

local_gemfile = File.expand_path('Gemfile.local', __dir__)
eval_gemfile local_gemfile if File.exist?(local_gemfile)
