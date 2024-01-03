# frozen_string_literal: true

task release: 'changelog:check_clean' # Before task is required

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
require_relative 'lib/rubocop/cop/generator'

# JRuby and Windows don't support fork, so we can't use minitest-queue.
if RUBY_ENGINE == 'jruby' || RuboCop::Platform.windows?
  Rake::TestTask.new do |t|
    t.libs << 'test'
    t.libs << 'lib'
    t.test_files = FileList['test/**/*_test.rb']
  end
else
  desc 'Run tests'
  task :test do
    error_on_failure = ENV.fetch('ERROR_ON_TEST_FAILURE', 'true') != 'false'

    system("bundle exec minitest-queue #{Dir.glob('test/**/*_test.rb').shelljoin}", exception: error_on_failure)
  end
end

desc 'Run RuboCop over itself'
RuboCop::RakeTask.new(:internal_investigation)

task default: %i[documentation_syntax_check test internal_investigation]

desc 'Generate a new cop template'
task :new_cop, [:cop] do |_task, args|
  require 'rubocop'

  cop_name = args.fetch(:cop) do
    warn "usage: bundle exec rake 'new_cop[Department/Name]'"
    exit!
  end

  generator = RuboCop::Cop::Generator.new(cop_name)

  generator.write_source
  generator.write_test
  generator.inject_require(root_file_path: 'lib/rubocop/cop/minitest_cops.rb')
  generator.inject_config(config_file_path: 'config/default.yml')

  puts generator.todo
end

def bump_minor_version
  major, minor, _patch = RuboCop::Minitest::Version::STRING.split('.')

  "#{major}.#{minor.succ}"
end
