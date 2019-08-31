# frozen_string_literal: true

require 'bundler'
require 'bundler/gem_tasks'

Dir['tasks/**/*.rake'].each { |t| load t }

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'rubocop/rake_task'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'Run RuboCop over itself'
RuboCop::RakeTask.new(:internal_investigation).tap do |task|
  if RUBY_ENGINE == 'ruby' &&
     RbConfig::CONFIG['host_os'] !~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    task.options = %w[--parallel]
  end
end

task default: %i[
  documentation_syntax_check
  generate_cops_documentation
  test
  internal_investigation
]
