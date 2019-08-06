require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = FileList["test/**/*_test.rb"]
end

task default: :test
