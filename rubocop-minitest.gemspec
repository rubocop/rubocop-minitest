# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/rubocop/minitest/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop-minitest'
  spec.version = RuboCop::Minitest::Version::STRING
  spec.authors = ['Bozhidar Batsov', 'Jonas Arvidsson', 'Koichi ITO']

  spec.summary = 'Automatic Minitest code style checking tool.'
  spec.description = <<~DESCRIPTION
    Automatic Minitest code style checking tool.
    A RuboCop extension focused on enforcing Minitest best practices and coding conventions.
  DESCRIPTION
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.7.0'
  spec.metadata = {
    'homepage_uri' => 'https://docs.rubocop.org/rubocop-minitest/',
    'changelog_uri' => 'https://github.com/rubocop/rubocop-minitest/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/rubocop/rubocop-minitest',
    'documentation_uri' => "https://docs.rubocop.org/rubocop-minitest/#{RuboCop::Minitest::Version.document_version}",
    'bug_tracker_uri' => 'https://github.com/rubocop/rubocop-minitest/issues',
    'rubygems_mfa_required' => 'true',
    'default_lint_roller_plugin' => 'RuboCop::Minitest::Plugin'
  }

  spec.files = Dir['LICENSE.txt', 'README.md', 'config/**/*', 'lib/**/*']

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'lint_roller', '~> 1.1'
  spec.add_dependency 'rubocop', '>= 1.75.0', '< 2.0'
  spec.add_dependency 'rubocop-ast', '>= 1.38.0', '< 2.0'
end
